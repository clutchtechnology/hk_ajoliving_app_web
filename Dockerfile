# 多阶段构建 Flutter Web 应用

# ==================== 构建阶段 ====================
FROM ghcr.io/cirruslabs/flutter:3.24.0 AS builder

# 设置工作目录
WORKDIR /app

# 复制 pubspec 文件
COPY pubspec.yaml pubspec.lock ./

# 获取依赖
RUN flutter pub get

# 复制项目文件
COPY . .

# 构建 Web 应用（生产环境）
RUN flutter build web --release --web-renderer canvaskit

# ==================== 生产阶段 ====================
FROM nginx:alpine

# 安装 timezone 数据
RUN apk add --no-cache tzdata

# 设置时区为香港
ENV TZ=Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 删除默认的 nginx 配置
RUN rm -rf /usr/share/nginx/html/*

# 从构建阶段复制构建产物
COPY --from=builder /app/build/web /usr/share/nginx/html

# 复制自定义 nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]
