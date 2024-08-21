#!/bin/bash

VERSION="patch" 

# Get parameters
while getopts v: flag
do
  case "${flag}" in
    v) VERSION=${OPTARG};;
  esac
done

# Get highest tag number, and add v0.1.0 if it doesn't exist
git fetch --tags --prune --unshallow 2>/dev/null || git fetch --tags --prune 2>/dev/null
CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null)

if [[ -z "$CURRENT_VERSION" ]]
then
  CURRENT_VERSION='v0.1.0'
fi
echo "Current Version: $CURRENT_VERSION"

# Remove the 'v' prefix if it exists
CURRENT_VERSION=${CURRENT_VERSION#v}

# Split the version into its components
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"

# Assign the version parts, ensuring they are numbers
VNUM1=${VERSION_PARTS[0]:-0}
VNUM2=${VERSION_PARTS[1]:-0}
VNUM3=${VERSION_PARTS[2]:-0}

# Debugging output
echo "Parsed Version Parts -> VNUM1: $VNUM1, VNUM2: $VNUM2, VNUM3: $VNUM3"
echo "Requested version bump type: $VERSION"

# Increment the appropriate version number
case $VERSION in
  major)
    VNUM1=$((VNUM1+1))
    VNUM2=0
    VNUM3=0
    ;;
  minor)
    VNUM2=$((VNUM2+1))
    VNUM3=0
    ;;
  patch)
    VNUM3=$((VNUM3+1))
    ;;
  *)
    echo "No version type (https://semver.org/) or incorrect type specified, try: -v [major, minor, patch]"
    exit 1
    ;;
esac

# Create the new version tag
NEW_TAG="v$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_TAG"

# Check if the current commit already has a tag
GIT_COMMIT=$(git rev-parse HEAD)
NEEDS_TAG=$(git describe --contains $GIT_COMMIT 2>/dev/null)

# Only tag if no tag already exists for this commit
if [ -z "$NEEDS_TAG" ]; then
  echo "Tagged with $NEW_TAG"
  git tag $NEW_TAG
  git push --tags
else
  echo "Already a tag on this commit"
fi

echo "::set-output name=git-tag::$NEW_TAG"
exit 0
