#!/bin/bash
env
envsubst '${DOMAIN_NAME}' < /nginx.conf > /etc/nginx/conf.d/00-default.conf
cat /etc/nginx/conf.d/00-default.conf
nginx -g 'daemon off;'