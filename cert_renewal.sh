 #!/bin/bash
  2 if command -v docker >/dev/null 2>&1; then
  3         docker stop trojan6&&systemctl stop nginx
  4 else
  5         systemctl stop nginx
  6 fi
  7 /usr/bin/certbot renew --force-renewal --quiet;
  8 if command -v docker >/dev/null 2>&1; then
  9         docker start trojan6&&systemctl start nginx
 10 else
 11         systemctl start nginx
 12 fi
