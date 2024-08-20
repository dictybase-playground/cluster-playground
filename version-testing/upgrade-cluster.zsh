#!/bin/zsh
echo "Updating cluster..."

if ! kops update cluster --yes; then
    echo "Error encountered during kops update"
    exit 1
fi
if ! kops export kubeconfig --admin; then
    echo "Error encountered during kubeconfig export with version"
    exit 1
fi
if ! kops validate cluster --wait 10m; then
    echo "Error encountered during cluster validation with version"
    exit 1
fi

echo "Successfully updated cluster"
