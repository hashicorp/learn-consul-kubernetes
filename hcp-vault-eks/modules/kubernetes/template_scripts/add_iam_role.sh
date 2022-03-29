#!/usr/bin/env bash

set -e

# Add the IAM Role to the aws-auth config in order to use kubectl while inside the pod.
# The IAM Role variable preserves the YAML formatting in its partial to fed to awk
# awk merges this partial block into the existing aws-auth config.
IAM_ROLE=$(tr -d '\n' < aws_auth.yaml | sed 's/      /      \\n/g' | sed 's/\\n  /\\n      /g')
kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$IAM_ROLE\";next}1" > aws-auth-patch.yaml
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat aws-auth-patch.yaml)"
rm aws-auth-patch.yaml
rm aws_auth.yaml
