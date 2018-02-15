require "test_helper"

describe Fluent::Plugin::KubernetesObjectsInput do
  include Fluent::Test::Helpers
  include PluginTestHelper

  before {
    Fluent::Test.setup # setup router and others
    stub_k8s_requests
  }
    
  it { expect(::Fluent::Plugin::KubernetesObjectsInput::VERSION).wont_be_nil }

  it "should require at least one <pull> or <watch> section" do
    expect{create_input_driver("kubernetes_url #{k8s_url}")}.must_raise Fluent::ConfigError
    expect(create_input_driver(<<~CONF)).wont_be_nil
    kubernetes_url #{k8s_url}
    <pull>
    resource_name nodes
    </pull>
    CONF
    expect(create_input_driver(<<~CONF)).wont_be_nil
    kubernetes_url #{k8s_url}
    <watch>
    resource_name nodes
    </watch>
    CONF
  end

  describe "config: kubernetes_url" do
    it "should read from environment variables by default" do
      ENV['KUBERNETES_SERVICE_HOST'] = k8s_host
      ENV['KUBERNETES_SERVICE_PORT'] = k8s_port
      expect(create_input_driver(<<~CONF).instance.kubernetes_url).must_equal k8s_url
      <pull>
      resource_name nodes
      </pull>
      CONF
    end

    it "should panic if not set" do
      ENV['KUBERNETES_SERVICE_HOST'] = nil
      ENV['KUBERNETES_SERVICE_PORT'] = nil
      expect{ create_input_driver(<<~CONF) }.must_raise Fluent::ConfigError
      <pull>
      resource_name nodes
      </pull>
      CONF
    end
  end

  describe "emit events" do
    it "can pull one resource" do
      d = create_input_driver(<<~CONF)
      kubernetes_url #{k8s_url}
      <pull>
      resource_name nodes
      </pull>
      CONF

      d.run expect_emits: 1, timeout: 3
      events = d.events

      expect(events[0][0]).must_equal 'kubernetes.nodes'
    end

    it "can pull multiple resources" do
      d = create_input_driver(<<~CONF)
      kubernetes_url #{k8s_url}
      <pull>
      resource_name namespaces
      </pull>
      <pull>
      resource_name pods
      </pull>
      CONF

      d.run expect_emits: 2, timeout: 3
      events = d.events

      expect(events.any? { |e| e[0] == 'kubernetes.pods'}).must_equal true
      expect(events.any? { |e| e[0] == 'kubernetes.namespaces'}).must_equal true
    end

    it "can watch resources" do
      d = create_input_driver(<<~CONF)
      kubernetes_url #{k8s_url}
      <watch>
      resource_name events
      </watch>
      CONF

      d.run expect_emits: 1, timeout: 3
      events = d.events
      expect(events.all? { |e| e[0] == 'kubernetes.events'}).must_equal true
    end
  end
end
