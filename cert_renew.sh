#!/bin/bash
docker stop trojan6
systemctl stop nginx
/usr/bin/certbot renew --force-renewal --quiet
systemctl start nginx
docker start trojan6
