#!/usr/bin/env bash
set -e
TAG=$1

# Install dependecies
gem install bundler
bundle update --bundler
bundle install

# Build Gem
rake build -t -v
cp pkg/fluent-plugin-kubernetes-metrics-*.gem docker

# Build Docker Image
VERSION=`cat VERSION`
FLUENTD_HEC_GEM_VERSION=`cat docker/FLUENTD_HEC_GEM_VERSION`
docker build --build-arg VERSION=$VERSION --build-arg FLUENT_SPLUNK_HEC_GEM_VERSION=$FLUENTD_HEC_GEM_VERSION --no-cache -t splunk/kube-objects:$TAG ./docker
