# Kubernetes Services Object
### SourceType: kube:object:services

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#service-v1-core

Field | Description | Example
----- | ----------- | -------
metadata.name | Service name | kubernetes
spec.clusterIP | clusterIP is the IP address of the service | 10.100.0.1
spec.externalName | external reference that discovery mechanisms will return as an alias for this service  | frontend.company.com
spec.externalTrafficPolicy | externalTrafficPolicy denotes if this Service desires to route external traffic to node-local or cluster-wide endpoints | Cluster
spec.ports{}.nodePort | The port on each node on which this service is exposed | 30245
spec.ports{}.name | The name of this port within the service | https
spec.ports{}.port | The port that will be exposed by this service | 443
spec.ports{}.protocol | The IP protocol for this port | TCP
spec.selector.name | Route service traffic to pods with label keys and values matching this selector | Webfrontend
spec.type| How the Service is exposed | ClusterIP
