# /Users/xxx/grafana/data 目录，准备用来挂载放置grafana的数据
# /Users/xxx/grafana/plugins 目录，准备用来放置grafana的插件
# /Users/xxx/grafana/config 目录，准备用来挂载放置grafana的配置文件
mkdir -p /usr/local/grafana/{data,plugins,config}

# 如果需要授权相关文件夹权限，可以参考下面的命令
chmod -R 777 /usr/local/grafana/data
chmod -R 777 /usr/local/grafana/plugins
chmod -R 777 /usr/local/grafana/config


# 先临时启动一个容器
docker run --name grafana-tmp -d -p 3000:3000 grafana/grafana
# 将容器中默认的配置文件拷贝到宿主机上
docker cp grafana-tmp:/etc/grafana/grafana.ini /usr/local//grafana/config/grafana.ini
# 移除临时容器
docker stop grafana-tmp
docker rm grafana-tmp

# 修改配置文件（需要的话）
# vim /usr/local/grafana/config/grafana.ini


# 启动grafana
# 环境变量GF_SECURITY_ADMIN_PASSWORD：指定admin的密码
# 环境变量GF_INSTALL_PLUGINS：指定启动时需要安装得插件
#         grafana-clock-panel代表时间插件
#         grafana-simple-json-datasource代表json数据源插件
#         grafana-piechart-panel代表饼图插件

docker run -d \
    -p 3000:3000 \
    --name=grafana \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/local/grafana/data:/var/lib/grafana \
    -v /usr/local/grafana/plugins/:/var/lib/grafana/plugins \
    -v /usr/local/grafana/config/grafana.ini:/etc/grafana/grafana.ini \
    -e "GF_SECURITY_ADMIN_PASSWORD=admin" \
    -e "GF_INSTALL_PLUGINS=grafana-worldmap-panel,grafana-clock-panel,grafana-simple-json-datasource,grafana-piechart-panel,volkovlabs-echarts-panel,satellogic-3d-globe-panel,aceiot-svg-panel,ryantxu-ajax-panel,yesoreyeram-boomtable-panel,netsage-bumpchart-panel,marcusolsson-calendar-panel,integrationmatters-comparison-panel,jdbranham-diagram-panel,natel-discrete-panel,larona-epict-panel,agenty-flowcharting-panel,grafana-polystat-panel" \
    grafana/grafana
