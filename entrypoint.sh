#!/usr/bin/env bash

service mysql start
echo "create database lportal character set utf8;" | mysql -u root -padmin
cd /opt/liferay/liferay-ce-portal-7.0-ga3/tomcat-8.0.32/bin/
. ./catalina.sh run

