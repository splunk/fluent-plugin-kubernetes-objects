require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.expand_path('..', __dir__))

# suppress warning, when require the 'http' library shows circle require warning
# which is pretty annoying (kubeclient depends on http for watch_stream)
_verbose = $VERBOSE
$VERBOSE = nil
$VERBOSE = _verbose

require 'fluent/test'
require 'fluent/test/driver/input'
require 'fluent/test/helpers'
require 'minitest/autorun'
require 'webmock/minitest'

# make assertions from webmock available in minitest/spec
module Minitest::Expectations
  infect_an_assertion :assert_requested, :must_be_requested, :reverse
  infect_an_assertion :assert_not_requested, :wont_be_requested, :reverse
end

module PluginTestHelper
  def k8s_host
    '127.0.0.1'
  end

  def k8s_port
    '8001'
  end

  def k8s_url(path = 'api')
    "https://#{k8s_host}:#{k8s_port}/#{path}"
  end

  def fluentd_conf_for(*lines)
    basic_config = []
    (basic_config + lines).join("\n")
  end

  def create_input_driver(*configs)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::KubernetesObjectsInput).tap do |d|
      d.configure(fluentd_conf_for(*configs))
    end
  end

  def stub_k8s_requests
    # all stub response bodies are from real k8s 1.8 API calls
    stub_k8s_api
    stub_k8s_apis
    stub_k8s_v1
    stub_k8s_namespaces
    stub_k8s_nodes
    stub_k8s_pods
    stub_k8s_events
  end

  def stub_k8s_api
    File.open(File.expand_path('api.json', __dir__)).tap do |f|
      stub_request(:get, k8s_url).to_return(body: f.read)
    end.close
  end

  def stub_k8s_apis
    File.open(File.expand_path('apis.json', __dir__)).tap do |f|
      stub_request(:get, k8s_url('apis')).to_return(body: f.read)
    end.close
  end

  def stub_k8s_v1
    File.open(File.expand_path('v1.json', __dir__)).tap do |f|
      stub_request(:get, "#{k8s_url}/v1").to_return(body: f.read)
    end.close
  end

  def stub_k8s_namespaces
    File.open(File.expand_path('namespaces.json', __dir__)).tap do |f|
      stub_request(:get, "#{k8s_url}/v1/namespaces").to_return(body: f.read)
    end.close
  end

  def stub_k8s_nodes
    File.open(File.expand_path('nodes.json', __dir__)).tap do |f|
      stub_request(:get, "#{k8s_url}/v1/nodes").to_return(body: f.read)
    end.close
  end

  def stub_k8s_pods
    File.open(File.expand_path('pods.json', __dir__)).tap do |f|
      stub_request(:get, "#{k8s_url}/v1/pods").to_return(body: f.read)
    end.close
  end

  def stub_k8s_events(params: nil)
    File.open(File.expand_path('events.json', __dir__)).tap do |f|
      url = "#{k8s_url}/v1/watch/events"
      url << '?' << params.map { |k, v| "#{k}=#{v}" }.join('&') if params
      stub_request(:get, url)
        .to_return(body: f.read,
                   headers: { 'Content-Type' => 'application/json',
                              'Transfer-Encoding' => 'chunked' })
    end.close
  end
end
