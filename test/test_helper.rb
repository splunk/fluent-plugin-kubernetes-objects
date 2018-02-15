$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
#$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

# suppress warning, when require the 'http' library, it shows circle require warnning,
# which is pretty annoying (kubeclient depends on http for watch_stream)
_verbose = $VERBOSE
$VERBOSE = nil
require "fluent/plugin/in_kubernetes_objects"
$VERBOSE = _verbose

require "fluent/test"
require "fluent/test/driver/input"
require "fluent/test/helpers"
require "minitest/autorun"
require "webmock/minitest"

# make assertions from webmock available in minitest/spec
module Minitest::Expectations
  infect_an_assertion :assert_requested, :must_be_requested, :reverse
  infect_an_assertion :assert_not_requested, :wont_be_requested, :reverse
end

module PluginTestHelper
  def k8s_host() "127.0.0.1" end
  def k8s_port() "8001" end
  def k8s_url() "https://#{k8s_host}:#{k8s_port}/api" end

  def fluentd_conf_for(*lines)
    basic_config = [
    ]
    (basic_config + lines).join("\n")
  end

  def create_input_driver(*configs)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::KubernetesObjectsInput).tap { |d|
      d.configure(fluentd_conf_for(*configs))
    }
  end

  def stub_k8s_requests
    # all stub response bodies are from real k8s 1.8 API calls
    stub_k8s_api
    stub_k8s_v1
    stub_k8s_namespaces
    stub_k8s_nodes
    stub_k8s_pods
    stub_k8s_events
  end

  def stub_k8s_api
    open(File.expand_path('../api.json', __FILE__)).tap { |f|
      stub_request(:get, k8s_url).to_return(body: f.read)
    }.close
  end

  def stub_k8s_v1
    open(File.expand_path('../v1.json', __FILE__)).tap { |f|
      stub_request(:get, "#{k8s_url}/v1").to_return(body: f.read)
    }.close
  end

  def stub_k8s_namespaces
    open(File.expand_path('../namespaces.json', __FILE__)).tap { |f|
      stub_request(:get, "#{k8s_url}/v1/namespaces").to_return(body: f.read())
    }.close
  end

  def stub_k8s_nodes
    open(File.expand_path('../nodes.json', __FILE__)).tap { |f|
      stub_request(:get, "#{k8s_url}/v1/nodes").to_return(body: f.read())
    }.close
  end

  def stub_k8s_pods
    open(File.expand_path('../pods.json', __FILE__)).tap { |f|
      stub_request(:get, "#{k8s_url}/v1/pods").to_return(body: f.read())
    }.close
  end

  def stub_k8s_events
    open(File.expand_path('../events.json', __FILE__)).tap { |f|
      stub_request(:get, "#{k8s_url}/v1/watch/events").
	to_return(body: f.read(), headers: {"Content-Type" => "application/json", "Transfer-Encoding" => "chunked"})
    }.close
  end
end
