FROM jenkins/jnlp-slave:4.3-4-alpine

MAINTAINER Ruslan Ponomarenko <xtmprz@gmail.com>
LABEL Description="Jenkins slave for k8s plugin, with additional tools: sed, jq, yq, helm, kubectl"

ARG DOCKER_CLI_VERSION="19.03.11"
ENV DOCKER_DOWNLOAD_URL="https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz"

ARG YQ_VERSION="3.3.0"
USER root

RUN apk --update add --no-cache ca-certificates bash git curl gawk sed grep jq openssl coreutils \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && curl -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod a+x /usr/local/bin/yq \
    && mkdir -p /tmp/download \
    && curl -L $DOCKER_DOWNLOAD_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && rm -rf /tmp/download \
    && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*
