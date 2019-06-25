# frozen_string_literal: true

require 'fluent/plugin/input'
require 'kubeclient'

module Fluent::Plugin
  class KubernetesObjectsInput < Fluent::Plugin::Input
    VERSION = '1.1.2'.freeze

    Fluent::Plugin.register_input('kubernetes_objects', self)

    helpers :storage, :thread

    desc 'The tag of the event.'
    config_param :tag, :string, default: 'kubernetes.*'

    desc 'URL of the kubernetes API.'
    config_param :kubernetes_url, :string, default: nil

    desc 'Kubernetes API version.'
    config_param :api_version, :string, default: 'v1'

    desc 'Path to the certificate file for this client.'
    config_param :client_cert, :string, default: nil

    desc 'Path to the private key file for this client.'
    config_param :client_key, :string, default: nil

    desc 'Path to the CA file.'
    config_param :ca_file, :string, default: nil

    desc "If `insecure_ssl` is set to `true`, it won't verify apiserver's certificate."
    config_param :insecure_ssl, :bool, default: false

    desc 'Path to the file contains the API token. By default it reads from the file "token" in the `secret_dir`.'
    config_param :bearer_token_file, :string, default: nil

    desc "Path of the location where pod's service account's credentials are stored."
    config_param :secret_dir, :string, default: '/var/run/secrets/kubernetes.io/serviceaccount'

    desc 'Define a resource to pull.'
    config_section :pull, required: false, init: false, multi: true, param_name: :pull_objects do
      desc 'The name of the resource, e.g. "nodes".'
      config_param :resource_name, :string

      desc 'The namespace of the resource, it pulls from all namespaces if not set.'
      config_param :namespace, :string, default: nil

      desc 'A selector to restrict the list of returned objects by labels.'
      config_param :label_selector, :string, default: nil

      desc 'A selector to restrict the list of returned objects by fields.'
      config_param :field_selector, :string, default: nil

      desc 'The interval at which the objects will be pulled.'
      config_param :interval, :time, default: 15 * 60
    end

    desc 'Define a resource to watch.'
    config_section :watch, required: false, init: false, multi: true, param_name: :watch_objects do
      desc 'The name of the resource, e.g. "events".'
      config_param :resource_name, :string

      desc 'The namespace of the resource, it watches all namespaces if not set.'
      config_param :namespace, :string, default: nil

      desc 'The name of the entity to watch, use this to watch only one entity.'
      config_param :entity_name, :string, default: nil

      desc 'A selector to restrict the list of returned objects by labels.'
      config_param :label_selector, :string, default: nil

      desc 'A selector to restrict the list of returned objects by fields.'
      config_param :field_selector, :string, default: nil

      desc 'The interval at which the objects will be watched.'
      config_param :interval, :time, default: 15 * 60
    end

    config_section :storage do
      # use memory by default
      config_set_default :usage, 'checkpoints'
      config_set_default :@type, 'local'
      config_set_default :persistent, false
    end

    def configure(conf)
      super

      raise Fluent::ConfigError, 'At least one <pull> or <watch> is required, but found none.' if @pull_objects.empty? && @watch_objects.empty?

      @storage = storage_create usage: 'checkpoints'

      parse_tag
      initialize_client
    end

    def start
      super
      start_pullers
      start_watchers
    end

    def close
      super
    end

    private

    def parse_tag
      @tag_prefix, @tag_suffix = @tag.split('*') if @tag.include?('*')
    end

    def generate_tag(item_name)
      return @tag unless @tag_prefix

      [@tag_prefix, item_name, @tag_suffix].join
    end

    def init_with_kubeconfig()
      options = {}
      config = Kubeclient::Config.read @kubeconfig
      current_context = config.context

      @client = Kubeclient::Client.new(
        current_context.api_endpoint,
        current_context.api_version,
        options.merge(
          ssl_options: current_context.ssl_options,
          auth_options: current_context.auth_options
        )
      )
    end

    def initialize_client
      # mostly borrowed from Fluentd Kubernetes Metadata Filter Plugin
      if @kubernetes_url.nil?
        # Use Kubernetes default service account if we're in a pod.
        env_host = ENV['KUBERNETES_SERVICE_HOST']
        env_port = ENV['KUBERNETES_SERVICE_PORT']
        if env_host && env_port
          @kubernetes_url = "https://#{env_host}:#{env_port}/#{@api_version == 'v1' ? 'api' : 'apis'}"
        end
      end

      raise Fluent::ConfigError, 'kubernetes url is not set' unless @kubernetes_url

      # Use SSL certificate and bearer token from Kubernetes service account.
      if Dir.exist?(@secret_dir)
        secret_ca_file = File.join(@secret_dir, 'ca.crt')
        secret_token_file = File.join(@secret_dir, 'token')

        if @ca_file.nil? && File.exist?(secret_ca_file)
          @ca_file = secret_ca_file
        end

        if @bearer_token_file.nil? && File.exist?(secret_token_file)
          @bearer_token_file = secret_token_file
        end
      end

      ssl_options = {
        client_cert: @client_cert && OpenSSL::X509::Certificate.new(File.read(@client_cert)),
        client_key: @client_key && OpenSSL::PKey::RSA.new(File.read(@client_key)),
        ca_file: @ca_file,
        verify_ssl: @insecure_ssl ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
      }

      auth_options = {}
      auth_options[:bearer_token] = File.read(@bearer_token_file) if @bearer_token_file

      @client = Kubeclient::Client.new(
        @kubernetes_url, @api_version,
        ssl_options: ssl_options,
        auth_options: auth_options
      )

      begin
          @client.api_valid?
      rescue KubeException => kube_error
        raise Fluent::ConfigError, "Invalid Kubernetes API #{@api_version} endpoint #{@kubernetes_url}: #{kube_error.message}"
        end
    end

    def start_pullers
      @pull_objects.each(&method(:create_pull_thread))
    end

    def start_watchers
      @watch_objects.each(&method(:create_watcher_thread))
    end

    def create_pull_thread(conf)
      options = conf.to_h.dup
      options[:as] = :raw
      resource_name = options.delete :resource_name
      pull_interval = options.delete :interval

      thread_create :"pull_#{resource_name}" do
        tag = generate_tag resource_name
        while thread_current_running?
          log.debug "Going to pull #{resource_name}"
          response = @client.public_send "get_#{resource_name}", options
          now = Fluent::Engine.now
          es = Fluent::MultiEventStream.new

          # code copied from kubeclient
          # kubeclient will create one open struct object for each item in the response,
          # but this is totally unecessary in this plugin, thus we use as: :raw.
          result = JSON.parse(response)

          resource_version = result.fetch('resourceVersion') do
            result.fetch('metadata', {})['resourceVersion']
          end

          update_op = if resource_version
                        ->(item) { item['metadata'].update requestResourceVersion: resource_version }
                      else
                        ->(item) {}
                      end

          # result['items'] might be nil due to https://github.com/kubernetes/kubernetes/issues/13096
          items = result['items'].to_a
          log.debug { "Received #{items.size} #{resource_name}" }
          items.each { |item| es.add now, item.tap(&update_op) }
          router.emit_stream(tag, es)

          sleep(pull_interval)
        end
      end
    end

    def create_watcher_thread(conf)
      options = conf.to_h.dup
      options[:as] = :raw
      resource_name = options[:resource_name]
      version = @storage.get(resource_name)
      if version
        options[:resource_version] = version
      else
        options[:resource_version] = 0
      end

      thread_create :"watch_#{resource_name}" do
        while thread_current_running?
          @client.public_send("watch_#{resource_name}", options).tap do |watcher|
            tag = generate_tag "#{resource_name}"
            watcher.each do |entity|
              begin
                entity = JSON.parse(entity)
                router.emit tag, Fluent::Engine.now, entity
                options[:resource_version] = entity['object']['metadata']['resourceVersion']
                @storage.put resource_name, entity['object']['metadata']['resourceVersion']
              rescue => e
                log.info "Got exception #{e} parsing entity #{entity}. Resetting watcher."
              end
            end
          end
        end
      end
    end
  end
end

