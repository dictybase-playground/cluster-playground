#!/bin/zsh
if ! kubectl apply -f ../configmaps/dictycr-configuration.yml; then
  echo "Error encountered while running workload"
  exit 1
fi
if ! kubectl apply -f ../secrets/dictycr-secret-dev.yml; then
  echo "Error encountered while running workload"
  exit 1
fi
if ! kubectl apply -f ../deployments/stockcenter-api-server.yml; then
  echo "Error encountered while running workload"
  exit 1
fi
