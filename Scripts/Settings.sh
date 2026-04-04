#!/bin/bash

# 判断是否传入必要的参数
if [ -z "$OWRT_THEME" ] || [ -z "$OWRT_IP" ] || [ -z "$OWRT_NAME" ] || [ -z "$OWRT_URL" ]; then
    echo "错误: 必须设置 OWRT_THEME, OWRT_IP, OWRT_NAME 和 OWRT_URL 环境变量"
    exit 1
fi

CFG_FILE="./package/base-files/files/bin/config_generate"

# 删除冲突插件
rm -rf $(find ./ ../feeds/luci/ ../feeds/packages/ -maxdepth 3 -type d \( -iname "*argon*" -o -iname "*openclash*" -o -iname "*lucky*" \) -prune)


# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-$WRT_THEME/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")

#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$WRT_NAME'/g" $CFG_FILE

# 修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" $CFG_FILE
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" $CFG_FILE

# 根据源码来修改（仅当链接包含 "lede" 时）
if [[ $OWRT_URL == *"lede"* ]]; then
    # 修改默认时间格式
    find ./package/*/autocore/files/ -type f -name "index.htm" -exec sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' {} \;
fi

#配置文件修改
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config

echo "OpenWrt 配置修改完成！"
