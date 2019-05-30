#!/usr/bin/env bash
set -ex
# force a failure if there's no tag
git describe --tags
# now get the tag
CURRENT_TAG=$(git describe --tags)
# convert v0.2.12-2-g50254a9 to 0.2.12
CURRENT_TAG_VERSION=$(git describe --tags | cut -f1 -d'-')
# if there's a hash on the tag, then this is not a release tagged commit
if [ "$CURRENT_TAG" != "$CURRENT_TAG_VERSION" ]; then
    echo "Current tag version is not a release tag, cut a new release if you want to publish."
    exit 1
fi
curl -sL "https://www.nuget.org/packages/AWSCRT/${CURRENT_TAG_VERSION}" -o /tmp/AWSCRT.${CURRENT_TAG_VERSION}.nupkg
curl -sL "https://www.nuget.org/packages/AWSCRT-HTTP/${CURRENT_TAG_VERSION}" -o /tmp/AWSCRT-HTTP.${CURRENT_TAG_VERSION}.nupkg
if [ -e /tmp/AWSCRT.${CURRENT_TAG_VERSION}.nupkg ] &&  [ -e /tmp/AWSCRT-HTTP.${CURRENT_TAG_VERSION}.nupkg ]; then
    echo "$CURRENT_TAG_VERSION is already in NuGet, cut a new release if you want to publish."
    exit 1
fi

echo "$CURRENT_TAG_VERSION currently does not exist in NuGet, allowing pipeline to continue."
exit 0
