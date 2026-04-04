#!/bin/bash

#Argon Theme
git clone --depth=1 --single-branch https://github.com/jerrykuku/luci-theme-argon.git
git clone --depth=1 --single-branch https://github.com/jerrykuku/luci-app-argon-config.git
#Linkease
git clone --depth=1 --single-branch https://github.com/linkease/istore.git
git clone --depth=1 --single-branch https://github.com/linkease/nas-packages.git
git clone --depth=1 --single-branch https://github.com/linkease/nas-packages-luci.git

# packages
#git clone --depth=1 --single-branch https://github.com/kiddin9/openwrt-packages.git kiddin9

# adguardHome
git clone --depth=1 --single-branch https://github.com/rufengsuixing/luci-app-adguardhome.git

# lucky
git clone --depth=1 --single-branch https://github.com/gdy666/luci-app-lucky.git

#Open Clash
git clone --depth=1 --single-branch --branch "dev" https://github.com/vernesong/OpenClash.git

#预置OpenClash内核和GEO数据
export CORE_VER=https://raw.githubusercontent.com/vernesong/OpenClash/refs/heads/core/dev/core_version
export CORE_MATE=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/meta/clash-linux

export CORE_TYPE=$(echo $OWRT_TARGET | grep -Eiq "64|86" && echo "amd64" || echo "arm64")
export TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")

export GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
export GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
export GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat

cd ./OpenClash/luci-app-openclash/root/etc/openclash

curl -sfL -o ./Country.mmdb $GEO_MMDB
curl -sfL -o ./GeoSite.dat $GEO_SITE
curl -sfL -o ./GeoIP.dat $GEO_IP

mkdir ./core && cd ./core

curl -sfL -o ./meta.tar.gz "$CORE_MATE"-"$CORE_TYPE".tar.gz
tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta

chmod +x ./clash* ; rm -rf ./*.gz
