#!/bin/bash
mkdir /etc/letsencrypt/cert_renew
git clone https://github.com/michaeltwo/onekey.git
cp cert_renew.sh /etc/letsencrypt/cert_renew
chmod +x /etc/letsencrypt/cert_renew/cert_renew.sh
#crontab -e
echo '0 0 12 */2 * /etc/letsencrypt/cert_renew/cert_renew.sh > /dev/null 2>&1' /var/spool/cron/root
systemctl restart crond
