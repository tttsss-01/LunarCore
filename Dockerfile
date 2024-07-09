# 使用官方的 OpenJDK 17 基础镜像
FROM openjdk:17-jdk-slim

# 安装 Git 和其他必要工具
RUN apt-get update && apt-get install -y git curl

# 安装 MongoDB（建议安装）
RUN apt-get install -y mongodb

# 设置工作目录
WORKDIR /app

# 克隆项目代码
RUN git clone https://github.com/Melledy/LunarCore.git .

# 下载并放置资源文件
RUN mkdir -p resources && \
    cd resources && \
    git clone https://github.com/Dimbreath/StarRailData.git . && \
    curl -L https://gitlab.com/Melledy/LunarCore-Configs/-/archive/main/LunarCore-Configs-main.tar.gz | tar xz --strip=1

# 编译服务端核心
RUN ./gradlew jar

# 暴露应用程序端口（假设应用程序使用端口3000）
EXPOSE 3000

# 设置 MongoDB 数据目录
VOLUME ["/data/db"]

# 设置启动命令
CMD ["java", "-jar", "build/libs/LunarCore.jar"]
