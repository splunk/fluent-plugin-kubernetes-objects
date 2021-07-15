# Kubernetes Persistent_Volume_Claims Object
### SourceType: kube:object:persistent_volume_claims

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#persistentvolumeclaim-v1-core

Field | Description | Example
----- | ----------- | -------
metadata.name | Persistent Volume Claim Name | pvc-var-splunk-dev-standalone-0
spec.resources.requests.storage | Minimum amount of compute resources required | 100Gi
spec.storageClassName | Name of the StorageClass required by the claim | microk8s-hostpath
spec.volumeName | Binding reference to the PersistentVolume backing this claim | pvc-4073c97f-0b85-418c-9b64-ed5154875ec8
status.capacity.storage | Actual resources of the underlying volume | 100Gi
status.phase | Indicates if a volume is available, bound to a claim, or released by a claim | Bound