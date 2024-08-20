#!/bin/zsh
VERSION="$1"

if [ -z $VERSION ]; then
  echo "Error encountered: No version provided"
  exit 1
fi

echo "Changing to kops version $VERSION..."

if ! asdf install kops $VERSION; then 
  echo "Error encountered during kops version $VERSION installation"
  exit 1
fi

if ! asdf local kops $VERSION; then
  echo "Error encountered using kops version $VERSION"
  exit 1
fi

echo "Using kops $(kops version)"
