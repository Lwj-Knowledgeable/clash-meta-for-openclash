#!/bin/sh
current_version=$(cat Makefile | grep PKG_VERSION | head -n 1 | cut -d "=" -f 2)
echo "Current version: $current_version"

latest_version=$(curl -s https://api.github.com/repos/${1}/releases/latest | grep tag_name | cut -d '"' -f 4 | tr -d 'v')
echo "Latest version: $latest_version"

if [ "$current_version" = "$latest_version" ]; then
    echo "No update"
    exit 0
else
    wget https://github.com/${1}/archive/refs/tags/v$latest_version.tar.gz -O $2
    hash=$(sha256sum $2 | cut -d " " -f 1)
    sed -i '' "s/PKG_HASH:=.*/PKG_HASH:=$hash/g" Makefile
    rm $2

    echo "Update to $latest_version"
    sed -i '' "s/PKG_VERSION:=.*/PKG_VERSION:=$latest_version/g" Makefile
fi