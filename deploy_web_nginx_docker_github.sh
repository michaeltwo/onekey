#!/bin/sh
#===安装docker-ce以及配置===
wget --no-check-certificate https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker && systemctl enable docker
# completion of command, optional 
#yum -y install bash-completion
#source /etc/profile.d/bash_completion.sh
#===拉取镜像===
docker pull nginx
#创建配置文件path和WWW path
mkdir /usr/local/server
mkdir /usr/local/server/nginx
#mkdir /usr/local/server/nginx/conf && mkdir /usr/local/server/nginx/www

#由于github网速不稳定，使用循环判断，直到生成文件才停止
#拉取github的nginx conf到相应的目录
until [ -f /usr/local/server/nginx/conf/nginx.conf ]
do 
echo "pulling github config"
git clone https://github.com/michaeltwo/conf.git
cd conf
tar -zxvf conf.tar.gz -C /usr/local/server/nginx
done
#同样原理拉取github中得web文件
until [ -f /usr/local/server/nginx/jjwww/index.html ]
do 
echo "pulling github web"
git clone https://github.com/michaeltwo/jjweb.git
cd jjweb
tar -zxvf jjweb.tar.gz -C /usr/local/server/nginx
done

#运行docker container WITH nginx images, 使用--restart=always跟随宿主启动
docker run -dit --name=nginx -p 80:80 -p 443:443 -v /usr/local/server/nginx/conf/:/etc/nginx -v /usr/local/server/nginx/www:/usr/share/nginx/jjweb --restart=always nginx


#如果遇到问题则跑一遍新docker nginx并拷贝配置文件和共享文件到本地，以下为拷贝命令
#docker cp 601476e1851c:/etc/nginx/ /usr/local/server/nginx/conf
#docker cp 601476e1851c:/usr/share/nginx/html/ /usr/local/server/nginx/www

