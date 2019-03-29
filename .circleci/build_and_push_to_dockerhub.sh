#!/usr/bin/env bash
set -e
echo "Building docker image..."
cp /tmp/pkg/fluent-plugin-kubernetes-objects-*.gem docker
VERSION=`cat VERSION`
docker build --build-arg VERSION=$VERSION --build-arg FLUENT_SPLUNK_HEC_GEM_VERSION=$FLUENT_SPLUNK_HEC_GEM_VERSION --no-cache -t splunk/fluent-plugin-kubernetes-objects:ci ./docker
docker tag splunk/fluent-plugin-kubernetes-objects:ci splunk/${DOCKERHUB_REPO_NAME}:${VERSION}
echo "Push docker image to splunk dockerhub..."
docker login --username=$DOCKERHUB_ACCOUNT_ID --password=$DOCKERHUB_ACCOUNT_PASS
docker push splunk/${DOCKERHUB_REPO_NAME}:${VERSION} | awk 'END{print}'
echo "Docker image pushed successfully to docker-hub."