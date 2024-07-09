
FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y git curl gnupg

# add MongoDB APT 
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
    && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# install MongoDB
RUN apt-get update && apt-get install -y mongodb-org

RUN mkdir -p /LunarCore

WORKDIR /LunarCore
COPY . .

RUN chmod +x ./gradlew
RUN chmod +x ./docker-start.sh

RUN ./gradlew jar

EXPOSE 23301 80 27017

CMD ["/LunarCore/start.sh"]
