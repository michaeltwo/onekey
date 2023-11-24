#!/bin/bash
#deploy jjweb service without docker.running in centos 7.9,kernel X. Free space larger then 5G
#pre. domain registry via cloudflare or alicloud. point dns resolve to the host/ALB which you bought with public IP
#for domian, if the domain name is not www.dt-jj.com, pls replace line 42 with the right domain of certificate name
#ssh to the host with root user&&cd /opt or cd /var as manual partition.cd ~ by automatic.But here we cd /home
cd /home
# 1.basic tools installation
#yum -y install git
yum -y install epel-release
yum -y install yum-utils
yum -y install nginx
yum -y install nginx-mod-stream
# 2. get apps&configs
git clone https://github.com/michaeltwo/jjweb.git
git clone https://github.com/michaeltwo/nginx_sni.git
# 3. certificate app & get certificates in folder /etc/letsencrypt/live
yum -y install snapd
echo "snapd installed"
echo "enabling snapd.socket"
sudo systemctl enable --now snapd.socket
echo "---while confirm shell is done---"
while [ $? -ne 0 ];
do !!;
done
sudo ln -s /var/lib/snapd/snap /snap
while [ $? -ne 0 ];
do !!;
done
sudo snap install core; sudo snap refresh core
while [ $? -ne 0 ];
do !!;
done
sudo snap install --classic certbot
while [ $? -ne 0 ];
do !!;
done
sudo ln -s /snap/bin/certbot /usr/bin/certbot
while [ $? -ne 0 ];
do !!;
done
echo "creating first certificate, please type 'Y'"
sudo certbot certonly --standalone -d www.dt-jj.com  -m weihua.zheng@Hotmail.com --agree-tos
# 4. reallocate conf files & start nginx
cd nginx_sni
mkdir /etc/nginx/vhosts
yes|cp nginx.conf /etc/nginx/
yes|cp www.dt-jj.com.conf /etc/nginx/vhosts
yes|cp dt-jj.com.conf /etc/nginx/vhosts
# cp web files to relevant folder
yes|cp -r /home/jjweb/* /usr/share/nginx/html/
# start nginx
systemctl start nginx.service && systemctl enable nginx.service
#5. if check everything is ok
echo "---if to check last step is ok---NOTE:space"
if [ $? -eq 0 ]
then
echo "success"
else
echo "failed!"
exit 1
fi
