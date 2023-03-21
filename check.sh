#!/bin/sh
current_version=$(cat Makefile | grep PKG_VERSION | head -n 1 | cut -d "=" -f 2)
echo "Current version: $current_version"

latest_version=$(curl -s https://api.github.com/repos/MetaCubeX/Clash.Meta/releases/latest | grep tag_name | cut -d '"' -f 4 | tr -d 'v')
echo "Latest version: $latest_version"

if [ "$current_version" = "$latest_version" ]; then
    echo "No update"
    exit 0
else
    wget https://github.com/MetaCubeX/Clash.Meta/archive/refs/tags/v$latest_version.tar.gz -O clash.meta.tar.gz
    hash=$(sha256sum clash.meta.tar.gz | cut -d " " -f 1)
    sed -i '' "s/PKG_HASH:=.*/PKG_HASH:=$hash/g" Makefile
    rm clash.meta.tar.gz

    echo "Update to $latest_version"
    sed -i '' "s/PKG_VERSION:=.*/PKG_VERSION:=$latest_version/g" Makefile
fi