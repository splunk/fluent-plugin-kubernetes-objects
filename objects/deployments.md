# Kubernetes Deployments Object
### SourceType: kube:object:deployments

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#deployment-v1-apps

Field | Description | Example
----- | ----------- | -------
metadata.name | Deployment name | cartservice
spec.replicas | Number of desired pods | 1
spec.strategy.type | Type of deployment | RollingUpdate
spec.template.spec.containers{}.image | Docker image name | gcr.io/google-samples/microservices-demo/cartservice:v0.2.2
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
spec.template.spec.serviceAccountName | name of the ServiceAccount to use to run this pod | default	
status.availableReplicas | number of available pods | 1	
status.conditions{}.message	ReplicaSet | A human readable message indicating details about the transition | "cartservice-67b89ffc69" has successfully progressed
status.readyReplicas | number of ready pods targeted by this deployment | 1	