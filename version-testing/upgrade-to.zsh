#!/bin/zsh
# 1. Get the current version of kops
# 2. Get the target version of kops
# 3. truncate the `v` from the version tags
# 4. Create arrays where each element is a separate part of current version and target version
#     ex: v1.27.1 => 1.27.1 => [1, 27, 1]
# 5. Compare the n-th element of both arrays.
#     If current > target
#       exit with an error
#     else:
#       proceed

# TARGET_VERSION must be greater than current version
# TARGET_VERSION must in the acceptable target range
TARGET_KOPS_VERSION="$1"
CURRENT_KOPS_VERSION=$(kops version --short)
ACCEPTABLE_KOPS_VERSIONS=(1.27.1 1.27.2 1.27.3 1.28.0 1.28.1 1.28.2 1.28.3 1.28.4 1.28.5 1.28.7 1.29.0 1.29.2)
TARGET_IS_VALID=false

if [ -z $TARGET_KOPS_VERSION ]; then
  echo "Error encountered: No version provided"
  exit 1
fi

if [[ $TARGET_KOPS_VERSION == $CURRENT_KOPS_VERSION ]]; then
  echo "Already using kops $TARGET_KOPS_VERSION"
  exit 1
fi
# Check if the target version is an acceptable version to test
for version in "${ACCEPTABLE_KOPS_VERSIONS[@]}"; do
  if [[ "$version" == "$TARGET_KOPS_VERSION" ]]; then
    echo "Kops version $TARGET_KOPS_VERSION is valid"
    TARGET_IS_VALID=true
    break
  fi
done

if ! $TARGET_IS_VALID; then
    echo "Kops version $TARGET_KOPS_VERSION is invalid"
    exit 1
fi

# Check if the target is greater than the current version
IFS='.' read -r -A current <<< "$CURRENT_KOPS_VERSION"
IFS='.' read -r -A target <<< "$TARGET_KOPS_VERSION"

for i in {0..2}; do
  if (( current[i] > target[i] )); then
    echo "Current kops version $CURRENT_KOPS_VERSION is higher than target $TARGET_KOPS_VERSION"
    exit 1
  fi
done

# Create an array of acceptable kops versions from $CURRENT_KOPS_VERSION (exclusive) to $TARGET_KOPS_VERSION (inclusive)
VERSION_RANGE=()
FOUND_CURRENT=false

for version in "${ACCEPTABLE_KOPS_VERSIONS[@]}"; do
  # Check if the version is greater than the current version
  if [[ "$version" == "$CURRENT_KOPS_VERSION" ]]; then
    FOUND_CURRENT=true
    continue  # Skip the current version
  fi

  # If we have found the current version, start adding to the range
  if $FOUND_CURRENT; then
    VERSION_RANGE+=("$version")
  fi

  # Stop adding versions once we reach the target version
  if [[ "$version" == "$TARGET_KOPS_VERSION" ]]; then
    break
  fi
done

echo "Using kops versions:"
printf "%s\n" "${VERSION_RANGE[@]}"

for version in "${VERSION_RANGE[@]}"; do
  just set-kops-version "v$version" >> ./logs/${version}
  just upgrade
done
