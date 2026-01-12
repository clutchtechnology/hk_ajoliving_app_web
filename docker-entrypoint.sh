#!/bin/sh
set -e

echo "Starting Nginx on port 8080..."

# 测试 Nginx 配置
nginx -t

# 启动 Nginx
exec nginx -g "daemon off;"
