#!/usr/bin/env bash

container=$(docker ps | grep liferay70 | awk '{print $1}')
echo "connecting to $container"
docker exec -it $container bash
