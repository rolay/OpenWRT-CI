#!/bin/bash

# 判断是否传入必要的参数
if [ -z "$OWRT_THEME" ] || [ -z "$OWRT_IP" ] || [ -z "$OWRT_NAME" ] || [ -z "$OWRT_URL" ]; then
    echo "错误: 必须设置 OWRT_THEME, OWRT_IP, OWRT_NAME 和 OWRT_URL 环境变量"
    exit 1
fi

# 删除冲突插件
rm -rf $(find ./ ../feeds/luci/ ../feeds/packages/ -maxdepth 3 -type d \( -iname "*argon*" -o -iname "*openclash*" -o -iname "*lucky*" \) -prune)


# 修改默认主题
find ./feeds/luci/collections/ -type f -name "Makefile" -exec sed -i "s/luci-theme-bootstrap/luci-theme-$OWRT_THEME/g" {} \;

# 修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$OWRT_IP/g" ./package/base-files/luci/bin/config_generate

# 修改默认主机名
sed -i "s/hostname='.*'/hostname='$OWRT_NAME'/g" ./package/base-files/luci/bin/config_generate

# 修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/luci/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/luci2/bin/config_generate

# 根据源码来修改（仅当链接包含 "lede" 时）
if [[ $OWRT_URL == *"lede"* ]]; then
    # 修改默认时间格式
    find ./package/*/autocore/files/ -type f -name "index.htm" -exec sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' {} \;
fi

echo "OpenWrt 配置修改完成！"
