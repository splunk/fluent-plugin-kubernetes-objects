FROM registry.access.redhat.com/ubi8/ruby-25

MAINTAINER DataEdge DataEdge@splunk.com

LABEL name="Splunk Connect for Kubernetes Objects container" \
      maintainer="DataEdge@splunk.com" \
      vendor="Splunk Inc." \
      version="1.1.3" \
      release="1.1.3" \
      summary="Splunk Connect for Kubernetes Objects container" \
      description="Splunk Connect for Kubernetes Objects container"

ARG VERSION
ENV VERSION=${VERSION}
ENV FLUENT_USER fluent

USER root

COPY *.gem /tmp/
COPY licenses /licenses

RUN wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
      chmod +x ./jq && \
      cp jq /usr/bin && \
      gem install -N fluentd:1.9.1 \
       fluent-plugin-prometheus:1.7.0 \
       fluent-plugin-record-modifier:2.1.0 \
       fluent-plugin-jq:0.5.1 \
       fluent-plugin-splunk-hec:${VERSION} \
       oj:3.10.2 \
       multi_json:1.14.1 \
       bigdecimal:2.0.0 \
       kubeclient:4.6.0 && \
      gem install -N /tmp/*.gem

RUN groupadd -r $FLUENT_USER && \
  useradd -r -g $FLUENT_USER $FLUENT_USER && \
  mkdir -p /fluentd/log fluentd/etc /fluentd/plugins &&\
  chown -R $FLUENT_USER /fluentd && chgrp -R $FLUENT_USER /fluentd

USER $FLUENT_USER
CMD exec fluentd -c /fluentd/etc/fluent.conf
