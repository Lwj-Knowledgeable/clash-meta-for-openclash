#!/bin/sh
cp feeds.conf.default feeds.conf
echo "src-link clash $(pwd)/clash" >> ./feeds.conf
./scripts/feeds update clash
./scripts/feeds update packages
make defconfig
./scripts/feeds install -p clash -f clash

make package/clash/download V=s
make package/clash/check V=s
make package/clash/compile V=s