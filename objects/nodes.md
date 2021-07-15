# Kubernetes Nodes Object
### SourceType: kube:object:nodes

All definitions can be found at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#node-v1-core

Field | Description | Example
----- | ----------- | -------
metadata.name | Node Name | ip-192-168-16-232.ec2.internal
status.addresses{}.address | List of addresses for the node | 192.168.16.232
status.addresses{}.type | Address types for the node that align to the addresses | InternalIP
status.allocatable.* | Resources of a node that are available for scheduling | 1930m, 2886616Ki
status.capacity.* | Total resources of a node | 2, 20959212Ki
status.conditions{}.message | Human readable message indicating details about last transition | kubelet has sufficient memory available
status.nodeInfo.architecture | Architecture reported by the node | amd64
status.nodeInfo.containerRuntimeVersion | ContainerRuntime Version reported by the node | docker://18.9.9
status.nodeInfo.kernelVersion | Kernel Version reported by the node | 4.14.177-139.253.amzn2.x86_64
status.nodeInfo.kubeProxyVersion | KubeProxy Version reported by the node | v1.15.11-eks-af3caf
status.nodeInfo.kubeletVersion | Kubelet Version reported by the node | v1.15.11-eks-af3caf
status.nodeInfo.operatingSystem | The Operating System reported by the node | linux
status.nodeInfo.osImage | OS Image reported by the node | Amazon Linux 2

