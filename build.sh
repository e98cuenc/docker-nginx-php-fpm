#!/bin/sh
docker build -t e98cuenc/nginx-php-fpm:latest . && \
echo "Run with: ./run.sh [DIRECTORY-WITH-WEB-PROJECT]"
echo "Give your host localhost the fake IP 172.16.123.1 to allow access from Docker:"
echo "$ sudo ifconfig lo0 alias 172.16.123.1"
