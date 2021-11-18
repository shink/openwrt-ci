#!/bin/bash

# import ssr-plus feeds
sed -i "/helloworld/d" feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default

# import ssr-plus feeds
sed -i "/passwall/d" feeds.conf.default
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git" >> feeds.conf.default

# import OpenClash feeds
sed -i "/openclash/d" feeds.conf.default
echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> feeds.conf.default
