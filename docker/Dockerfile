FROM ruby:2.7.4-buster as builder

ADD ./ /app/
WORKDIR /app
RUN gem install bundler
RUN bundle update --bundler
RUN bundle install

RUN bundle exec rake build -t -v

FROM registry.access.redhat.com/ubi8/ruby-27

ARG VERSION

LABEL name="Splunk Connect for Kubernetes Objects container" \
      maintainer="DataEdge@splunk.com" \
      vendor="Splunk Inc." \
      version=${VERSION} \
      release=${VERSION} \
      summary="Splunk Connect for Kubernetes Objects container" \
      description="Splunk Connect for Kubernetes Objects container"

ENV VERSION=${VERSION}
ENV FLUENT_USER fluent

USER root

COPY --from=builder /app/pkg/fluent-plugin-*.gem /tmp/

RUN mkdir /licenses
COPY --from=builder /app/LICENSE /licenses/LICENSE

RUN dnf install -y jq

COPY --from=builder /app/docker/Gemfile* ./
RUN yum update -y \
   && yum remove -y nodejs npm \
   && gem install bundler \
   && gem unpack /tmp/*.gem --target gem \
   && bundle install 

RUN groupadd -r $FLUENT_USER && \
  useradd -r -g $FLUENT_USER $FLUENT_USER && \
  mkdir -p /fluentd/log fluentd/etc /fluentd/plugins &&\
  chown -R $FLUENT_USER /fluentd && chgrp -R $FLUENT_USER /fluentd

USER $FLUENT_USER
CMD bundle exec fluentd -c /fluentd/etc/fluent.conf
