# Kubernetes Stateful_Sets Object
### SourceType: kube:object:stateful_sets

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#statefulset-v1-apps

Field | Description | Example
----- | ----------- | -------
metadata.name | StatefulSet name | cartservice
spec.replicas | Number of desired pods | 3
spec.serviceName | The name of the service that governs this StatefulSet | splunk-splunk-dev-monitoring-console-headless	
spec.template.spec.containers{}.image | Docker image name | 602321143452.dkr.ecr.us-east-1.amazonaws.com/eks/coredns:v1.8.0-eksbuild.1
spec.template.spec.containers{}.name | Name of the container | server	
spec.template.spec.containers{}.livenessProbe.* | Periodic probe of container liveness
spec.template.spec.containers{}.ports{}.containerPort | Number of port to expose on the pod's IP address | 7070	
spec.template.spec.containers{}.ports{}.protocol | TCP	Protocol for port | TCP	
spec.template.spec.containers{}.readinessProbe.* | Periodic probe of container service readiness
spec.template.spec.containers{}.resources.limits.cpu | maximum amount of compute resources allowed | 200m	
spec.template.spec.containers{}.resources.limits.memory | maximum amount of compute resources allowed |	300Mi	
spec.template.spec.containers{}.resources.requests.cpu | minimum amount of compute resources required | 200m	
spec.template.spec.containers{}.resources.requests.memory | minimum amount of compute resources required |300Mi	
spec.template.spec.containers{}.volumeMounts{}.mountPath | Path within the container at which the volume should be mounted | /fluentd/etc	
spec.template.spec.containers{}.volumeMounts{}.name | This must match the Name of a Volume | conf-configmap	
spec.template.spec.containers{}.volumeMounts{}.readOnly | Mounted read-only if true, read-write otherwise | TRUE	
status.currentReplicas | Number of Pods created by the StatefulSet controller from the StatefulSet version indicated by currentRevision | 2
status.readyReplicas | number of ready pods targeted by this deployment | 2
status.replicas | number of non-terminated pods targeted by this deployment | 2	