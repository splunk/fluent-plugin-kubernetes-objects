#!/usr/bin/env bash
set -e
gem install bundler
bundle update --bundler
bundle install