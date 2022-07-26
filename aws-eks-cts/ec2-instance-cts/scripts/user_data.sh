#!/usr/bin/env bash

cd /home/ubuntu
echo "${setup}" | base64 -d | zcat >setup.sh
chown ubuntu:ubuntu setup.sh
chmod +x setup.sh
./setup.sh
