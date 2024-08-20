#!/bin/zsh
echo "Running clean up..."
if ! kubectl delete configmap dictycr-configuration; then
    echo "Error encountered while running workload"
    exit 1
fi
if ! kubectl delete secret dictycr-secret-dev; then
    echo "Error encountered while running workload"
    exit 1
fi
if ! kubectl delete deployment stockcenter-api-server: then
    echo "Error encountered while running workload"
    exit 1
fi
