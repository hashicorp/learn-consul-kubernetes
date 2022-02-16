FROM alpine:3.15.0
LABEL org.opencontainers.image.source="https://github.com/hashicorp/learn-consul-kubernetes"
LABEL author="christian.weber@hashicorp.com"

ENV KUBECTL_VERSION=v1.22.4
ENV HELM_VERSION=v3.7.1
ENV GLIBC_VER=2.31-r0
ENV CONSUL_VERSION=1.11.3-ent


RUN apk update && \
    apk --no-cache add openssl curl yq jq bash vault consul libcap && \
    setcap cap_ipc_lock= /usr/sbin/vault && rm -rf /var/cache/apk/*

RUN curl -LO "https://dl.k8s.io/release/"${KUBECTL_VERSION}"/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version ${HELM_VERSION}

# install glibc compatibility for alpine to install aws cli
RUN apk --no-cache add \
        binutils \
       \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*


ENTRYPOINT ["/bin/bash"]