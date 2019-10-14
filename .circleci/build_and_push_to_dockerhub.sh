#!/usr/bin/env bash
set -e
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | 
    grep '"tag_name":' | 
    sed -E 's/.*"([^"]+)".*/\1/' 
}
FLUENTD_HEC_VERSION=`get_latest_release "splunk/fluent-plugin-splunk-hec"`

echo "Building docker image with Fluentd Hec Gem Version $FLUENTD_HEC_VERSION..."
cp /tmp/pkg/fluent-plugin-kubernetes-objects-*.gem docker
VERSION=`cat VERSION`
docker build --build-arg VERSION=$VERSION --build-arg FLUENT_SPLUNK_HEC_GEM_VERSION=$FLUENTD_HEC_VERSION --no-cache -t splunk/fluent-plugin-kubernetes-objects:ci ./docker
docker tag splunk/fluent-plugin-kubernetes-objects:ci splunk/${DOCKERHUB_REPO_NAME}:${VERSION}
echo "Push docker image to splunk dockerhub..."
docker login --username=$DOCKERHUB_ACCOUNT_ID --password=$DOCKERHUB_ACCOUNT_PASS
docker push splunk/${DOCKERHUB_REPO_NAME}:${VERSION} | awk 'END{print}'
echo "Docker image pushed successfully to docker-hub."