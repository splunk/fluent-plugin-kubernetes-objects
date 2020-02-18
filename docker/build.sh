#!/usr/bin/env bash
set -e
TAG=$1

# Install dependecies
gem install bundler
bundle update --bundler
bundle install

# Build Gem
bundle exec rake build -t -v
cp pkg/fluent-plugin-kubernetes-objects-*.gem docker

# Build Docker Image
VERSION=`cat VERSION`
FLUENTD_HEC_GEM_VERSION=`cat docker/FLUENTD_HEC_GEM_VERSION`
echo "Copying licenses to be included in the docker image..."
mkdir -p docker/licenses
cp -rp LICENSE docker/licenses/
docker build --build-arg VERSION=$VERSION --build-arg FLUENTD_HEC_GEM_VERSION=$FLUENTD_HEC_GEM_VERSION --no-cache -t splunk/kube-objects:$TAG ./docker
