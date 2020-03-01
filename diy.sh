#!/bin/bash
#=================================================
svn co --force https://github.com/coolsnowwolf/lede/trunk/package/lean package/lean && svn revert -R package/lean
rm -Rf package/lean/luci-app-ssr-plus
rm -Rf package/lean/qBittorrent/patches
sed -i 's/PKG_SOURCE_URL:=.*/PKG_SOURCE_URL:=https:\/\/github.com\/c0re100\/qBittorrent-Enhanced-Edition/g' package/lean/qBittorrent/Makefile
sed -i 's/PKG_HASH.*/PKG_SOURCE_PROTO:=git\nPKG_SOURCE_VERSION:=latest/g' package/lean/qBittorrent/Makefile
sed -i '/PKG_BUILD_DIR/d' package/lean/qBittorrent/Makefile
sed -i 's/+python$/+python3/g' package/lean/luci-app-qbittorrent/Makefile
rm -Rf feeds/packages/libs/boost
svn co --force https://github.com/coolsnowwolf/packages/trunk/libs/boost feeds/packages/libs/boost && svn revert -R feeds/packages/libs/boost
# sed -i 's/PKG_SOURCE_URL:=.*/PKG_SOURCE_URL:=https:\/\/github.com\/persmule\/amule-dlp/g' package/lean/amule/Makefile
# rm -Rf package/lean/amule/patches/001-amule-dlp.patch
rm -Rf package/feeds/packages/php7
svn co https://github.com/openwrt/packages/branches/openwrt-19.07/lang/php7 package/feeds/packages/php7
git clone https://github.com/mayswind/AriaNg-DailyBuild /files/www/ng
git clone https://github.com/MatteoRagni/AmuleWebUI-Reloaded files/usr/share/amule/webserver/AmuleWebUI-Reloaded
git clone https://github.com/kalcaddle/KodExplorer files/www/kod
git clone https://github.com/P3TERX/aria2.conf files/usr/share/aria2
rm -Rf package/lean/antileech/src/*
git clone https://github.com/persmule/amule-dlp.antiLeech package/lean/antileech/src

cd package/feeds
#git clone https://github.com/Lienol/openwrt-package
git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic
git clone https://github.com/rufengsuixing/luci-app-adguardhome
git clone https://github.com/jerrykuku/luci-theme-argon
git clone https://github.com/pymumu/luci-app-smartdns
# git clone https://github.com/LGA1150/openwrt-fullconenat
git clone https://github.com/lisaac/luci-app-diskman
mkdir parted && cp luci-app-diskman/Parted.Makefile parted/Makefile
# git clone https://github.com/mchome/luci-app-vlmcsd
# git clone https://github.com/mchome/openwrt-vlmcsd vlmcsd
# git clone https://github.com/KFERMercer/openwrt-v2ray v2ray
git clone https://github.com/lovelyOK/luci-app-haproxy-tcp
git clone https://github.com/tty228/luci-app-serverchan
git clone https://github.com/jerrykuku/luci-app-vssr
git clone https://github.com/lisaac/luci-app-dockerman
git clone https://github.com/lisaac/luci-lib-docker
git clone https://github.com/brvphoenix/luci-app-wrtbwmon
git clone https://github.com/brvphoenix/wrtbwmon
git clone https://github.com/destan19/OpenAppFilter
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt smartdns
svn co https://github.com/jsda/packages2/trunk/ntlf9t/luci-app-advancedsetting
git clone https://github.com/jerrykuku/lua-maxminddb.git
cd -

cp -Rf ../diy/* ./
sed -i 's/root\/.aria2/usr\/share\/aria2/g' files/usr/share/aria2/aria2.conf
sed -i '/rpc-secret/d' files/usr/share/aria2/aria2.conf
sed -i 's/+uhttpd //g' feeds/luci/collections/luci/Makefile
rm -Rf package/lean/wsdd2/patches/001-add_uuid_boot_id.patch
#rm -Rf package/feeds/packages/haproxy/files/haproxy.init
#sed -i 's/conf.$section/conf/g' package/feeds/packages/aria2/files/aria2.init
sed -i "s/sed '\/^$\/d' \"\$config_file_tmp\" >\"\$config_file\"/cd \/usr\/share\/aria2 \&\& .\/tracker.sh\ncat \/usr\/share\/aria2\/aria2.conf > \"\$config_file\"\necho '' >> \
\"\$config_file\"\nsed '\/^$\/d' \"\$config_file_tmp\" >> \"\$config_file\"/g" package/feeds/packages/aria2/files/aria2.init
sed -i '$a /etc/smartdns' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /www/nas/data' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /www/nas/plugins' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /www/nas/config/define.php' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /etc/qBittorrent' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /root/amule' package/base-files/files/lib/upgrade/keep.d/base-files-essential
find target/linux/x86 -name "config*" | xargs -i sed -i '$a # CONFIG_WLAN is not set\n# CONFIG_WIRELESS is not set\
\nCONFIG_NETFILTER_XT_MATCH_STRING=m\nCONFIG_HWMON=y\nCONFIG_SENSORS_CORETEMP=y' {}
#sed -i 's/fast_open="0"/fast_open="1"/g' package/*/luci-app-passwall/root/usr/share/passwall/subscription.sh
sed -i 's/if test_proxy/sleep 3600\nif test_proxy/g' package/*/luci-app-vssr/root/usr/bin/vssr-switch
sed -i 's/.*fast_open = 0/fast_open = 1/g' package/*/luci-app-vssr/root/usr/share/vssr/subscribe.lua
sed -i 's/service_start $PROG/service_start $PROG -R/g' package/feeds/packages/php7/files/php7-fpm.init
sed -i 's/net.netfilter.nf_conntrack_max=16384/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
wget -P package/network/config/firewall/patches/ https://github.com/coolsnowwolf/lede/raw/master/package/network/config/firewall/patches/fullconenat.patch
sed -i "s/('Drop invalid packets'));/('Drop invalid packets'));\n o = s.option(form.Flag, 'fullcone', _('Enable FullCone NAT'));/g" \
package/feeds/*/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js
sed -i "s/option forward		REJECT/option forward		REJECT\n	option fullcone	1/g" package/network/config/firewall/files/firewall.config
sed -i "s/option bbr '0'/option bbr '1'/g" package/*/luci-app-flowoffload/root/etc/config/flowoffload
sed -i "s/cgi-bin\///g" package/feeds/*/nginx/files-luci-support/luci.locations
sed -i "s/include conf.d/index luci;\n include conf.d/g" package/feeds/*/nginx/files/_lan.conf
sed -i 's/getElementById("cbid.amule.main/getElementById("widget.cbid.amule.main/g' package/lean/luci-app-amule/luasrc/view/amule/overview_status.htm
sed -i 's/main.extra_settings=""/main.extra_settings="dht-file-path=\/usr\/share\/aria2\/dht.dat"/g' package/feeds/*/luci-app-aria2/root/etc/uci-defaults/40_luci-aria2
getversion(){
if !(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$1/releases/latest) | grep -o -E "[0-9.]+")
then
  git ls-remote --tags git://github.com/$1 | cut -d/ -f3- | sort -t. -nk1,2 -k3 | awk '/^[^{]*$/{version=$1}END{print version}' | grep -o -E "[0-9.]+"
fi
}
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion v2ray/v2ray-core)/g" package/lean/v2ray/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion aria2/aria2)/g" package/feeds/*/aria2/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion Neilpang/acme.sh)/g" package/feeds/*/acme/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion netdata/netdata)/g" package/feeds/*/netdata/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion tsl0922/ttyd)/g" package/feeds/*/ttyd/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion docker/docker-ce)/g" package/feeds/*/docker-ce/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion cifsd-team/cifsd)/g" package/feeds/*/ksmbd/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(getversion cifsd-team/cifsd-tools)/g" package/feeds/*/ksmbd-tools/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=1.2.4/g" package/lean/rblibtorrent/Makefile
find package/feeds/*/aria2/ package/feeds/*/acme/ package/feeds/*/netdata/ package/feeds/*/ttyd/ package/feeds/*/docker-ce/ package/lean/v2ray/ \
package/feeds/*/ksmbd/ package/feeds/*/ksmbd-tools/ package/lean/rblibtorrent/ -maxdepth 2 -name "Makefile" | xargs -i sed -i "s/PKG_HASH:=.*/PKG_HASH:=skip/g" {}
sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' package/feeds/*/Makefile
find package/feeds/*/ package/lean/ -maxdepth 3 ! -path "*shadowsocksr-libev*" -name "Makefile" ! -path "*rblibtorrent*" -name "Makefile" \
| xargs -i sed -i "s/PKG_SOURCE_VERSION:=[0-9a-z]\{15,\}/PKG_SOURCE_VERSION:=latest/g" {}
sed -i 's/$(VERSION) &&/$(VERSION) ;/g' include/download.mk
