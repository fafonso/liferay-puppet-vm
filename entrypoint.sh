#!/usr/bin/env bash

service mysql start
echo "create database lportal character set utf8;" | mysql -u root -padmin
cd /opt/liferay/liferay-portal-6.2-ce-ga5/tomcat-7.0.62/bin/
. ./catalina.sh run

