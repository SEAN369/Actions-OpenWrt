#!/bin/bash
#=================================================
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean package/lean
cd package/feeds
git clone https://github.com/rufengsuixing/luci-app-adguardhome
git clone https://github.com/jerrykuku/luci-theme-argon
git clone https://github.com/pymumu/luci-app-smartdns
git clone https://github.com/LGA1150/openwrt-fullconenat
git clone https://github.com/rufengsuixing/luci-app-onliner
#git clone https://github.com/lisaac/luci-app-diskman
#mkdir parted && cp luci-app-diskman/Parted.Makefile parted/Makefile
# git clone https://github.com/mchome/luci-app-vlmcsd
git clone https://github.com/mchome/openwrt-vlmcsd vlmcsd
git clone https://github.com/KFERMercer/openwrt-v2ray v2ray
git clone https://github.com/lovelyOK/luci-app-haproxy-tcp
svn co https://github.com/project-openwrt/luci-app-unblockneteasemusic
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt smartdns
svn co https://github.com/project-openwrt/openwrt/trunk/package/jsda/luci-app-advancedsetting
svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-app-passwall
svn co https://github.com/Lienol/openwrt-package/trunk/package/tcping
cd -
sed -i '/^$/d' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set luci.main.mediaurlbase=/luci-static/bootstrap' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci commit luci' package/*/default-settings/files/zzz-default-settings
sed -i '/REDIRECT --to-ports 53/d' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set network.lan.ipaddr="10.0.0.2"' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set network.lan.ifname="eth1 eth3"' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan.proto=pppoe' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan.ifname=eth2' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan.username=555875jyyg' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan.password=700156' package/*/default-settings/files/zzz-default-settings
sed -i '$i uci commit network' package/*/default-settings/files/zzz-default-settings
sed -i '/openwrt_release/d' package/*/default-settings/files/zzz-default-settings
#sed -i '$i sed -i "$i iptables -t nat -A zone_wan_prerouting -j FULLCONENAT" /etc/firewall.user' package/*/default-settings/files/zzz-default-settings
#sed -i '$i sed -i "$i iptables -t nat -A zone_wan_postrouting -j FULLCONENAT" /etc/firewall.user' package/*/default-settings/files/zzz-default-settings
sed -i '$a /etc/smartdns' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i "s/option bbr '0'/option bbr '1'/g" package/*/luci-app-flowoffload/root/etc/config/flowoffload
find target/linux/x86 -name "config*" | xargs -i sed -i '$a # CONFIG_WLAN is not set' {}
find target/linux/x86 -name "config*" | xargs -i sed -i '$a # CONFIG_WIRELESS is not set' {}
#sed -i 's/fast_open="0"/fast_open="1"/g' package/*/luci-app-passwall/root/usr/share/passwall/subscription.sh
sed -i '/switch_enable/d' package/*/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.sh
sed -i 's/fast_open="0"/fast_open="1"/g' package/*/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.sh
sed -i 's/root::0:0:99999:7:::/root:$1$j4K9hIy0$M6mkXcqVVa3.kaZEsy8PX1:18255:0:99999:7:::/g' package/base-files/files/etc/shadow
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ --no-check-certificate https://raw.githubusercontent.com/LGA1150/fullconenat-fw3-patch/master/fullconenat.patch
#sed -i "s/('Drop invalid packets'));/('Drop invalid packets'));\n o = s.option(form.Flag, 'fullcone', _('Enable FullCone NAT'));/g" package/feeds/*/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js
sed -i "s/option forward		REJECT/option forward		REJECT\n	option fullcone	1/g" package/network/config/firewall/files/firewall.config
cd feeds/luci
wget -O- --no-check-certificate https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
cd -
function getversion(){
basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$1/$2/releases/latest) | sed "s/^v//g"
}
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion v2ray v2ray-core)/g" package/feeds/v2ray/Makefile
sed -i "s/PKG_HASH:=.*/PKG_HASH:=skip/g" package/feeds/v2ray/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion nondanee UnblockNeteaseMusic)/g" package/*/UnblockNeteaseMusic/Makefile
sed -i 's/PACKAGE_libcap:libcap/libcap/g' feeds/packages/net/samba4/Makefile
sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' package/feeds/*/Makefile
# sed -i 's/ucichanges = ucichanges + #j/for k, l in pairs(j) do	  for m, n in pairs(l) do   ucichanges = ucichanges + 1;   end     end/g' package/*/luci-theme-argon/luasrc/view/themes/argon/header.htm
find package/feeds package/lean -maxdepth 2 ! -path "*shadowsocksr-libev*" -name "Makefile" | xargs -i sed -i "s/PKG_SOURCE_VERSION:=[0-9a-z]\{15,\}/PKG_SOURCE_VERSION:=latest/g" {}
sed -i 's/ip6tables //g' include/target.mk
sed -i 's/odhcpd-ipv6only //g' include/target.mk
sed -i 's/odhcp6c //g' include/target.mk
sed -i 's/$(VERSION) &&/$(VERSION) ;/g' include/download.mk
