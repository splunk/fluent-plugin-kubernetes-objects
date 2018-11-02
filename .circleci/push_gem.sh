#!/usr/bin/env bash
set -e
sudo apt-get install -y python-pip libpython-dev > /dev/null 2>&1
echo "Installing aws cli..."
sudo pip install awscli > /dev/null 2>&1
echo "Pushing objects gem to s3..."
aws s3 cp pkg/*.gem s3://k8s-ci-artifacts/
