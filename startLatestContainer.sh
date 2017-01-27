#!/usr/bin/env bash

container=$(docker ps | grep liferay70 | awk '{print $1}'| head -1)
echo "restarting $container"
docker restart container
