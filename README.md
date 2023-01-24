# End of Support

**Important:** The fluent-plugin-kubernetes-objects will reach End of Support on January 1, 2024. After that date, this repository will no longer receive updates from Splunk and will no longer be supported by Splunk. Until then, only critical security fixes and bug fixes will be provided.

# fluent-plugin-kubernetes-objects

[Fluentd](https://fluentd.org/) input plugin to collect [objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) in a kubernetes cluster.

This input plugin can collects data in two ways:
* pull: it collects all available objects at a interval by calling the list APIs.
* watch: it collects only the new objects when they show up by calling the watch APIs.

## Installation

See also: [Plugin Management](https://docs.fluentd.org/v1.0/articles/plugin-management).

### RubyGems

```
$ gem install fluent-plugin-kubernetes-objects
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-kubernetes-objects"
```

And then execute:

```
$ bundle
```

## Configuration

### Example

```
<source>
  @type kubernetes_objects
  tag k8s.*

  <pull>
    resource_name nodes
  </pull>

  <pull>
    resource_name pods
    namespace default
  </pull>

  <watch>
    resource_name events
  </watch>
```

In this example, it will pull all the `nodes` , and all the `pods` in `default` namespace, and also watch `events`. And all those data will be tagged with prefix `"k8s."`.

### Parameters

#### @type (string) (required)

This must be `kubernetes_objects`.

#### tag (string) (optional)

The tag of the event.

`*` can be used as a placeholder that expands to the actual resource name (watch objects will have `.watch` suffix). For example, if you set

```
tag k8s.*
<pull>
  resource_name pods
</pull>
<watch>
  resource_name events
</watch>
```

The tag for `pods` data will be `k8s.pods`, while the tag for `events` will be `k8s.events.watch`.

Default value: `kubernetes.*`.

#### kubernetes_url (string) (optional)

The URL to the kubernetes API endpoint. By default, it will read from environment variables `KUBERNETES_SERVICE_HOST` and `KUBERNETES_SERVICE_PORT`. If those environment variables are not available, and this parameter is not set, error will be raised.

#### api_version (string) (optional)

Kubernetes API version, it includes the API group name and the version, just like the `apiVersion` in a Kubernetes manifests YAML file. E.g. `v1`, `rbac.authorization.k8s.io/v1`, etc.

Default value: `v1`.

#### client_cert (string) (optional)

Path to the certificate file for this client.

#### client_key (string) (optional)

Path to the private key file for this client.

#### ca_file (string) (optional)

Path to the CA file.

#### insecure_ssl (bool) (optional)

When set to `true`, it will ignore inscure `HTTPS` connections (i.e. it ignores server SSL certificate verification errors).

Default value: `false`.

#### secret_dir (string) (optional)

Path of the location where pod's service account's credentials are stored.th of the location where pod's service account's credentials are stored.

Default value: `/var/run/secrets/kubernetes.io/serviceaccount`.

#### bearer_token_file (string) (optional)

Path to the file contains the API token. By default it reads from the file "token" in the `secret_dir`.

#### &lt;pull&gt; Section (optional) (multiple)

Ths &lt;pull&gt; section is used to define which object to pull from the cluster. One section defines one object.

##### resource_name (string) (required)

The name of the object to pull. E.g. `pods`, `nodes`. This must match `api_version`.
The `resource_name` is not exactly the same as the name in Kubernetes API.
If a name contains multiple words, e.g. `daemonsets` and `replicasets`,
you will need use underscore `_` to separate the words.
So `daemonsets` becomes `daemon_sets`, and `replicasets` becomes `replica_sets`, and so on.

##### namespace (string) (optional)

Only the objects belong to the namespace specified in this parameter will be pulled. When it's not set, it will pull from all name spaces.

#### label_selector (string) (optional)

A selector to restrict the list of returned objects by labels.

#### field_selector (string) (optional)

A selector to restrict the list of returned objects by fields.

#### interval (time) (optional)

The interval at which the objects will be pulled.

Default value: `15m`.

#### &lt;watch&gt; Section (optional) (multiple)

Ths &lt;watch&gt; section is used to define which object to watch from the cluster. One section defines one object.

This section has exactly the same parameters except `interval` as the &lt;pull&gt; section does. Check the &lt;pull&gt; section above for details.

#### &lt;storage&gt; Section (optional) (single)

Defines where to storage checkpoints for `watch`. Each object the plugin watches, it will record the latest `resoruce_version` of that object. And when the fluentd restarts, the plugin will send the previously recorded `resource_version` to the kubernetes watch API.

By default, it uses the memory storage.

See also [Storage section configurations](https://docs.fluentd.org/v1.0/articles/storage-section) and [Storage Plugin Overview](https://docs.fluentd.org/v1.0/articles/storage-plugin-overview).

## License

See [License](LICENSE).
