# Kubernetes Daemon_Sets Object
### SourceType: kube:object:daemon_sets

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#daemonset-v1-apps

Field | Description | Example
----- | ----------- | -------
metadata.name | Daemon Set name | sck-splunk-kubernetes-metrics
spec.template.spec.containers{}.image | Docker image name | docker.io/splunk/k8s-metrics:1.1.4
spec.template.spec.containers{}.name | Name of the container | splunk-fluentd-k8s-metrics	
spec.template.spec.containers{}.resources.limits.cpu | maximum amount of compute resources allowed | 200m	
spec.template.spec.containers{}.resources.limits.memory | maximum amount of compute resources allowed |	300Mi	
spec.template.spec.containers{}.resources.requests.cpu | minimum amount of compute resources required | 200m	
spec.template.spec.containers{}.resources.requests.memory | minimum amount of compute resources required |300Mi	
spec.template.spec.containers{}.volumeMounts{}.mountPath | Path within the container at which the volume should be mounted | /fluentd/etc	
spec.template.spec.containers{}.volumeMounts{}.name | This must match the Name of a Volume | conf-configmap	
spec.template.spec.containers{}.volumeMounts{}.readOnly | Mounted read-only if true, read-write otherwise | TRUE	
spec.template.spec.serviceAccountName | name of the ServiceAccount to use to run this pod | splunk-kubernetes-metrics	
status.currentNumberScheduled | number of nodes that are running at least 1 daemon pod and are supposed to run the daemon pod | 1	
status.desiredNumberScheduled | number of nodes that should be running the daemon pod | 1	
status.numberAvailable | number of nodes that should be running the daemon pod and have one or more of the daemon pod running and available | 1	
status.numberReady | number of nodes that should be running the daemon pod and have one or more of the daemon pod running and ready | 1	