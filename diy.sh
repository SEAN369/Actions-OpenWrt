#!/bin/bash
#=================================================
rm -Rf package/lean
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean package/lean
rm -Rf package/lean/default-settings
# cp -rf ../default-settings package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/d' package/*/default-settings/files/zzz-default-settings
cat ../default-settings >> package/*/default-settings/files/zzz-default-settings
sed -i '/REDIRECT --to-ports 53/d' package/*/default-settings/files/zzz-default-settings
sed -i '/openwrt_release/d' package/*/default-settings/files/zzz-default-settings
cd package/feeds
#git clone https://github.com/Lienol/openwrt-package
git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic
git clone https://github.com/rufengsuixing/luci-app-adguardhome
git clone https://github.com/jerrykuku/luci-theme-argon
git clone https://github.com/pymumu/luci-app-smartdns
git clone https://github.com/LGA1150/openwrt-fullconenat
git clone -b openwrt-19 https://github.com/rufengsuixing/luci-app-onliner
git clone https://github.com/lisaac/luci-app-diskman
mkdir parted && cp luci-app-diskman/Parted.Makefile parted/Makefile
# git clone https://github.com/mchome/luci-app-vlmcsd
# git clone https://github.com/mchome/openwrt-vlmcsd vlmcsd
git clone https://github.com/KFERMercer/openwrt-v2ray v2ray
git clone https://github.com/lovelyOK/luci-app-haproxy-tcp
git clone https://github.com/tty228/luci-app-serverchan
git clone https://github.com/jerrykuku/luci-app-vssr
#svn co https://github.com/maxlicheng/luci-app-unblockmusic/trunk/UnblockNeteaseMusic
#svn co https://github.com/maxlicheng/luci-app-unblockmusic/trunk/app luci-app-unblockmusic
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt smartdns
svn co https://github.com/project-openwrt/openwrt/trunk/package/jsda/luci-app-advancedsetting
cd -

rm -Rf package/lean/wsdd2/patches/001-add_uuid_boot_id.patch
sed -i 's/cycle_time=60/cycle_time=1800/g' package/lean/luci-app-ssr-plus/root/usr/bin/ssr-switch
sed -i '$a /etc/smartdns' package/base-files/files/lib/upgrade/keep.d/base-files-essential
find target/linux/x86 -name "config*" | xargs -i sed -i '$a # CONFIG_WLAN is not set\n# CONFIG_WIRELESS is not set\nCONFIG_NETFILTER_XT_MATCH_STRING=m' {}
#sed -i 's/fast_open="0"/fast_open="1"/g' package/*/luci-app-passwall/root/usr/share/passwall/subscription.sh
sed -i '/switch_enable/d' package/*/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.sh
sed -i 's/fast_open="0"/fast_open="1"/g' package/*/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.sh
sed -i 's/net.netfilter.nf_conntrack_max=16384/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#mkdir package/network/config/firewall/patches
#wget -P package/network/config/firewall/patches/ --no-check-certificate https://raw.githubusercontent.com/Lienol/openwrt/my-19.07-full/package/network/config/firewall/patches/fullconenat.patch
sed -i "s/('Drop invalid packets'));/('Drop invalid packets'));\n o = s.option(form.Flag, 'fullcone', _('Enable FullCone NAT'));/g" package/feeds/*/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js
#sed -i "s/option forward		REJECT/option forward		REJECT\n	option fullcone	1/g" package/network/config/firewall/files/firewall.config
sed -i "s/option bbr '0'/option bbr '1'/g" package/*/luci-app-flowoffload/root/etc/config/flowoffload
#cd feeds/luci
#wget -O- --no-check-certificate https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
#cd -
function getversion(){
basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$1/$2/releases/latest) | sed "s/^v//g"
}
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion v2ray v2ray-core)/g" package/feeds/v2ray/Makefile
sed -i "s/PKG_HASH:=.*/PKG_HASH:=skip/g" package/feeds/v2ray/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion nondanee UnblockNeteaseMusic)/g" package/*/UnblockNeteaseMusic/Makefile
sed -i 's/PACKAGE_libcap:libcap/libcap/g' feeds/packages/net/samba4/Makefile
sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' package/feeds/*/Makefile
find package/feeds package/lean -maxdepth 3 ! -path "*shadowsocksr-libev*" -name "Makefile" | xargs -i sed -i "s/PKG_SOURCE_VERSION:=[0-9a-z]\{15,\}/PKG_SOURCE_VERSION:=latest/g" {}
sed -i 's/ip6tables //g' include/target.mk
sed -i 's/odhcpd-ipv6only //g' include/target.mk
sed -i 's/odhcp6c //g' include/target.mk
sed -i 's/$(VERSION) &&/$(VERSION) ;/g' include/download.mk
