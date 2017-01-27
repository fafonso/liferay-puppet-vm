#!/usr/bin/env bash

container=$(docker ps -a | grep liferay70 | awk '{print $1}'| head -1)

echo "trying to restart $container"
docker restart $container
