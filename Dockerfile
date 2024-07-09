
FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y git curl gnupg

# add MongoDB APT 
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
    && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# install MongoDB
RUN apt-get update && apt-get install -y mongodb-org

RUN mkdir -p /LunarCore
# RUN mkdir -p /resources


RUN if [ ! -d /resources/StarRailData ]; then \
    mkdir -p /resources/StarRailData && \
    curl -L https://github.com/Dimbreath/StarRailData/archive/master.tar.gz | tar -xz --strip-components=1 -C /resources/StarRailData; \
    fi 

RUN if [ ! -d /resources/LunarCore-Configs ]; then \
    mkdir -p /resources/LunarCore-Configs && \
    curl -L https://gitlab.com/Melledy/LunarCore-Configs/-/archive/main/LunarCore-Configs-main.tar.gz | tar -xz --strip-components=1 -C /resources/LunarCore-Configs; \
    fi

WORKDIR /LunarCore
COPY . .

RUN cp -rf /resources/StarRailData/* /LunarCore/
RUN cp -rf /resources/LunarCore-Configs/* /LunarCore/

RUN chmod +x ./gradlew

RUN ./gradlew jar

EXPOSE 27017

CMD ["java", "-jar", "LunarCore.jar"]
