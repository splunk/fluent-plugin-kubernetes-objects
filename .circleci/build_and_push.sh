#!/usr/bin/env bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | 
    grep '"tag_name":' | 
    sed -E 's/.*"([^"]+)".*/\1/' 
}
FLUENTD_HEC_VERSION=`get_latest_release "splunk/fluent-plugin-splunk-hec"`

aws ecr get-login --region $AWS_REGION --no-include-email | bash
echo "Building docker image with Fluentd Hec Gem Version $FLUENTD_HEC_VERSION..."
cp /tmp/pkg/fluent-plugin-kubernetes-objects-*.gem docker
echo "Copy latest fluent-plugin-splunk-hec gem from S3"
VERSION=`cat VERSION`
docker build --build-arg VERSION=$VERSION --build-arg FLUENT_SPLUNK_HEC_GEM_VERSION=$FLUENTD_HEC_VERSION --no-cache -t splunk/fluent-plugin-kubernetes-objects:ci ./docker
docker tag splunk/fluent-plugin-kubernetes-objects:ci $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/k8s-ci-objects:latest
echo "Push docker image to ecr..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/k8s-ci-objects:latest | awk 'END{print}'
echo "Docker image pushed successfully."