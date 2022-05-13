#!/usr/bin/env bash

mkdir -p $HOME/.kube && touch $HOME/.kube/config
yum install -y yum-utils
yum install -y git jq awscli tar vim
curl -LO "https://dl.k8s.io/release/v1.22.4/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum install -y terraform
