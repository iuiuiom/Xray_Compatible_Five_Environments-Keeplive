#!/bin/bash

# 随机US节点
cities=("atl" "bos" "den" "dfw" "ewr" "iad" "mia" "ord")
index=$(($RANDOM % ${#cities[@]}))
selected_city=${cities[$index]}

# 输出toml部署文件
cat > fly.toml << EOF
# fly.toml file generated for hells on 2023-04-22T08:17:40Z

app = "${FLY_APP_NAME}"
kill_signal = "SIGINT"
kill_timeout = 5
mounts = []
primary_region = "${selected_city}"
processes = []

[[services]]
  internal_port = 3000
  processes = ["app"]
  protocol = "tcp"
  [services.concurrency]
    hard_limit = 25
    soft_limit = 20
    type = "connections"

  [[services.ports]]
    force_https = true
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443
EOF
