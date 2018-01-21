#!/usr/bin/env bash

rm ignition.json
ct --strict --pretty --platform=ec2 --in-file rancher-server.yml > ignition.json && \
cat ignition.json | pbcopy

