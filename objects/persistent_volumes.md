# Kubernetes Persistent_Volumes Object
### SourceType: kube:object:persistent_volumes

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#persistentvolume-v1-core

Field | Description | Example
----- | ----------- | -------
metadata.name | Persistent Volume Name | pvc-ff21aff0-b715-4d6a-acec-f855ce2c7535
spec.capacity.storage | persistent volume's resources and capacity | 50Gi
spec.*type* | different types of persistent volumes that are defined
spec.persistentVolumeReclaimPolicy | What happens to a persistent volume when released from its claim | Delete
spec.storageClassName | Name of StorageClass to which this persistent volume belongs | microk8s-hostpath
status.phase | Indicates if a volume is available, bound to a claim, or released by a claim | Bound