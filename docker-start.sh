#!/bin/sh
if [ ! -d /resources/StarRailData ]; then
    mkdir -p /resources/StarRailData &&
        curl -L https://github.com/Dimbreath/StarRailData/archive/master.tar.gz | tar -xz --strip-components=1 -C /resources/StarRailData
fi

if [ ! -d /resources/LunarCore-Configs ]; then
    mkdir -p /resources/LunarCore-Configs &&
        curl -L https://gitlab.com/Melledy/LunarCore-Configs/-/archive/main/LunarCore-Configs-main.tar.gz | tar -xz --strip-components=1 -C /resources/LunarCore-Configs
fi

mkdir -p /LunarCore/resources
cp -rf /resources/StarRailData/* /LunarCore/resources/
cp -rf /resources/LunarCore-Configs/* /LunarCore/resources/

mongod --logpath /var/log/mongodb.log --bind_ip_all && java -jar /LunarCore/LunarCore.jar
