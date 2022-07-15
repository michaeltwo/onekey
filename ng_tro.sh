#!/bin/sh
# will deploy 2 apps via nginx_sni. nginx docker(此脚本是不用docker的方式) and trojangfw docker.
cd /home
# 1.basic tools installation, git should already be installed before git onekey shell
#yum -y install git
yum -y install epel-release
yum -y install yum-utils
yum -y install nginx
yum -y install nginx-mod-stream
# 2. install docker-ce
wget --no-check-certificate https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker && systemctl enable docker
# 3. get images
#docker pull nginx
docker pull fountain0/trojangfw:1.6
# 4. get apps&configs
git clone https://github.com/michaeltwo/jjweb.git
git clone https://github.com/michaeltwo/nginx_sni.git
# 5. certificate app & get certificates in folder /etc/letsencrypt/live
yum -y install snapd
echo "snapd installed"
echo "enabling snapd.socket"
sudo systemctl enable --now snapd.socket
echo "---try to pause few seconds to create ln--"
echo "please see the warnings if any questions"
sudo ln -s /var/lib/snapd/snap /snap
echo "---try to pause few seconds to create ln--"
echo "ln created,pls see any warnings, if any questions"
sudo snap install core; sudo snap refresh core
echo "---try to pause few seconds to refresh core--"
echo "ln created,pls see any warnings, if any questions"
sudo snap install --classic certbot
echo "---try to pause few seconds to create ln--"
echo "ln created,pls see any warnings, if any questions"
sudo ln -s /snap/bin/certbot /usr/bin/certbot
echo "---try to pause few seconds to create ln--"
echo "ln created,pls see any warnings, if any questions"
echo "creating first certificate, please type 'Y'"
sudo certbot certonly --standalone -d www.dt-jj.com  -m weihua.zheng@Hotmail.com --agree-tos
echo "creating second certificate"
sudo certbot certonly --standalone -d tro.dt-jj.com -m weihua.zheng@Hotmail.com --agree-tos
# 6. reallocate conf files & start dockers
cd nginx_sni
mkdir /etc/nginx/vhosts
yes|cp nginx.conf /etc/nginx/
yes|cp www.dt-jj.com.conf /etc/nginx/vhosts
yes|cp dt-jj.com.conf /etc/nginx/vhosts
mkdir /etc/trojan/
yes|cp config.json /etc/trojan/
# cp web files to relevant folder
yes|cp -r /home/jjweb/* /usr/share/nginx/html/
# start nginx
systemctl start nginx.service && systemctl enable nginx.service
# running trojan docker
docker run -dit --privileged=true --name=trojan6 -p 10241:10241 -v /etc/letsencrypt/live/tro.dt-jj.com/fullchain.pem:/path/to/fullchain.pem -v /etc/letsencrypt/live/tro.dt-jj.com/privkey.pem:/path/to/privkey.pem -v /etc/trojan/config.json:/config/config.json fountain0/trojangfw:1.6



