# 使用官方的 OpenJDK 17 基础镜像
FROM openjdk:17-jdk-slim

# 安装 Git 和其他必要工具
RUN apt-get update && apt-get install -y git curl gnupg

# 添加 MongoDB 官方的 APT 仓库
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
    && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# 更新包列表并安装 MongoDB
RUN apt-get update && apt-get install -y mongodb-org

# 设置工作目录
WORKDIR /app

# 克隆项目代码
RUN git clone https://github.com/Melledy/LunarCore.git .

# 下载并放置资源文件
RUN mkdir -p resources && \
    cd resources && \
    git clone https://github.com/Dimbreath/StarRailData.git . && \
    curl -L https://gitlab.com/Melledy/LunarCore-Configs/-/archive/main/LunarCore-Configs-main.tar.gz | tar xz --strip=1

# 为 gradlew 添加执行权限
RUN chmod +x ./gradlew

# 编译服务端核心
RUN ./gradlew jar

# 暴露应用程序端口（假设应用程序使用端口3000）
EXPOSE 3000

# 设置 MongoDB 数据目录
VOLUME ["/data/db"]

# 设置启动命令
CMD ["java", "-jar", "build/libs/LunarCore.jar"]
