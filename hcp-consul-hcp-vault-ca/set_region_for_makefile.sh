#!/usr/bin/env bash

TF_VAR_region=$(read -p "Enter the AWS Region to use for this project (e.g. us-east-1) > ")

if [ ! $TF_VAR_region ]; then
  # Set val if user skips entering any intput, and default to us-east-1
  TF_VAR_region="us-east-1"
  echo "region=\"${TF_VAR_region}\"" > terraform.tfvars
  echo "hcp_region=\"${TF_VAR_region}\"" >> terraform.tfvars
fi

exit 0