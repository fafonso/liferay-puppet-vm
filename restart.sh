#!/usr/bin/env bash

docker restart $(docker ps | grep liferay62 | awk '{print $1}')
