#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'

feeds_config='feeds.conf.default'
config_file='.config'
custom_feed_script='custom-feed.sh'
custom_config_script='custom-config.sh'

# 获取设备参数
if (($# == 0)); then
  echo -e -------- "${cyan}no args${none}" --------
  exit
fi

cd "$1" || exit

echo -e -------- "${cyan}Installing dependencies${none}" --------
sudo apt update
sudo apt install -y build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip \
  zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex node-uglify git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev \
  xmlto qemu-utils upx upx-ucl libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync

if [ ! -d lede ]; then
  echo -e -------- "${cyan}Cloning coolsnowwolf/lede${none}" --------
  git clone https://github.com/coolsnowwolf/lede.git
else
  echo -e -------- "${red}The lede directory already existed, recompiling${none}" --------
  git pull
  rm -rf lede/tmp && rm -rf lede/.config
fi

cd lede || exit
echo -e -------- "${cyan}Load custom feeds${none}" --------
[ -e ../$feeds_config ] && cp ../$feeds_config feeds.conf.default
../$custom_feed_script

echo -e -------- "${cyan}Update feeds${none}" --------
./scripts/feeds update -a

echo -e -------- "${cyan}Install feeds${none}" --------
./scripts/feeds install -a

echo -e -------- "${cyan}Load custom configuration${none}" --------
[ -e ../$config_file ] && cp ../$config_file .config
../$custom_config_script

echo -e -------- "${cyan}make menuconfig${none}" --------
#make menuconfig
make defconfig

echo -e -------- "${cyan}Downloading${none}" --------
make -j8 download V=s

trd=$(($(nproc) + 1))
echo -e -------- "${cyan}Compile with ${trd} thread(s)${none}" --------
#make -j1 V=s
make -j$(trd) V=s
