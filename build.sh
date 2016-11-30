#!/bin/sh
docker build -t e98cuenc/nginx-php-fpm:latest . && \
echo "Run with: ./run.sh [DIRECTORY-WITH-WEB-PROJECT]"
