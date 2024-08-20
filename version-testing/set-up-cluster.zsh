#!/bin/zsh
if kops get cluster; then
  kops delete cluster --yes
fi

kops create cluster --zones us-central1-a --yes 
kops export kubeconfig --admin
kops validate cluster --wait 10m
