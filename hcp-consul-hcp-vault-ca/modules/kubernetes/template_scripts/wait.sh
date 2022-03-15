#!/usr/bin/env bash

set -e

COUNTER=0

while [ $COUNTER -le 120 ]
do
  echo "Waiting for Pod to be ready"
  COUNTER=$(( $COUNTER + 5 ))
  sleep 5
done