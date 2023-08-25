#!/usr/bin/env bash
set -e

#Make sure to check and clean previously failed deployment
echo "Checking if previous deployment exist..."
if [ "`helm ls --short`" == "" ]; then
   echo "Nothing to clean, ready for deployment"
else
   helm delete $(helm ls --short)
fi

# Clone splunk-connect-for-kubernetes repo
cd /opt
git clone https://github.com/splunk/splunk-connect-for-kubernetes.git
cd splunk-connect-for-kubernetes

cat ci_scripts/sck_values.yml

minikube image load splunk/kube-objects:recent

echo "Deploying k8s-connect with latest changes"
helm install ci-sck --set global.splunk.hec.token=$CI_SPLUNK_HEC_TOKEN \
--set global.splunk.hec.host=$CI_SPLUNK_HOST \
--set kubelet.serviceMonitor.https=true \
--set splunk-kubernetes-objects.image.pullPolicy=IfNotPresent \
--set splunk-kubernetes-objects.image.tag=recent \
-f ci_scripts/sck_values.yml helm-chart/splunk-connect-for-kubernetes

kubectl get pod
# wait for deployment to finish
# metric and logging deamon set for each node + aggr + object + splunk
PODS=$((MINIKUBE_NODE_COUNTS*2+2+1))
until kubectl get pod | grep Running | [[ $(wc -l) == $PODS ]]; do
   kubectl get pod
   sleep 3;
done
