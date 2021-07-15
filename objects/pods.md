# Kubernetes Pods Object
### SourceType: kube:object:pods

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#pod-v1-core

Field | Description | Example
----- | ----------- | -------
metadata.name | Pod Name | adminfrontend-c8b48c574-dsl4q
spec.containers{}.image | Docker image name | docker.io/splunk/k8s-metrics:1.1.3
spec.containers{}.name | Container Name | splunk-fluentd-k8s-metrics
spec.containers{}.ports{}.containerPort | Number of port to expose on the pod's IP address | 443
spec.containers{}.volumeMounts{}.mountPath | Path within the container at which the volume should be mounted | /var/run/secrets/kubernetes.io/serviceaccount
spec.containers{}.volumeMounts{}.name | Volume's name that has been mounted | default-token-njbcn
spec.volumes{}.hostPath.path | Path of the directory on the host | /var/lib/docker/overlay2
spec.volumes{}.name | Volume's name | default-token-njbcn
spec.containers{}.livenessProbe.* | Information on periodic probe of container liveness	
spec.containers{}.readinessProbe.* | Information on periodic probe of container readiness
spec.containers{}.securityContext.privileged | Run container in privileged mode | TRUE
spec.containers{}.securityContext.allowPrivilegeEscalation | Whether a process can gain more privileges than its parent process | TRUE
spec.securityContext.runAsGroup | The GID to run the entrypoint of the container process | 4188	
spec.securityContext.runAsUser | The UID to run the entrypoint of the container process	| 4188
spec.securityContext.runAsNonRoot | Indicates that the container must run as a non-root user | 0
spec.serviceAccountName | ServiceAccount to use to run this pod | default 
status.containerStatuses{}.image | The image the container is running | k8tan/admin_frontend:latest
status.containerStatuses{}.name | Container name that is running | adminfrontend
status.containerStatuses{}.ready | Specifies whether the container has passed its readiness probe | TRUE
status.containerStatuses{}.restartCount | The number of times the container has been restarted | 1
status.containerStatuses{}.state.running.startedAt | Time at which the container was last (re-)started | 2020-07-28T16:41:29Z
status.hostIP | IP address of the host to which the pod is assigned | 192.168.16.232
status.message | Human readable message indicating details about why the pod is in this condition | Pod The node had condition: [MemoryPressure].
status.phase | High-level summary of where the Pod is in its lifecycle | Running
status.podIP | IP address allocated to the pod | 192.168.25.49
status.reason | Brief CamelCase message indicating details about why the pod is in this state | Evicted

