Gem::Specification.new do |spec|
  spec.name          = 'fluent-plugin-kubernetes-objects'
  spec.version       = File.read('VERSION')
  spec.authors       = ['Splunk Inc.']
  spec.email         = ['DataEdge@splunk.com']

  spec.summary       = 'Fluentd Plugin for Kubernetes Objects.'
  spec.description   = 'A Fluentd input plugin for collecting Kubernetes objects, e.g. pods, namespaces, events, etc. by pulling or watching.'
  spec.homepage      = 'https://github.com/splunk/fluent-plugin-kubernetes-objects'
  spec.license       = 'Apache-2.0'

  spec.require_paths = ['lib']
  spec.test_files    = Dir.glob('test/**/**.rb')
  spec.files         = %w[
    CODE_OF_CONDUCT.md README.md LICENSE
    fluent-plugin-kubernetes-objects.gemspec
    Gemfile Gemfile.lock
    Rakefile VERSION
  ] + Dir.glob('lib/**/**').reject(&File.method(:directory?))

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.required_ruby_version = '>= 2.3.0'
  spec.add_runtime_dependency 'fluentd', '>= 1.9.1'
  spec.add_runtime_dependency 'kubeclient', '~> 4.9.3'
  spec.add_runtime_dependency 'http_parser.rb', '= 0.5.3'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'test-unit', '~> 3.3' # required by fluent/test.rb
  spec.add_development_dependency 'webmock', '~> 3.5'
end
