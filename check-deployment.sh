#!/bin/bash

echo "=== 检查 Docker 容器状态 ==="
docker ps -a | grep ajoliving

echo -e "\n=== 检查容器日志 ==="
docker logs ajoliving-web --tail 50

echo -e "\n=== 检查 Nginx 配置 ==="
docker exec ajoliving-web nginx -t

echo -e "\n=== 检查网站文件 ==="
docker exec ajoliving-web ls -la /usr/share/nginx/html/

echo -e "\n=== 测试健康检查端点 ==="
docker exec ajoliving-web wget -O- http://localhost/health

echo -e "\n=== 测试主页 ==="
docker exec ajoliving-web wget -O- http://localhost/ | head -20
