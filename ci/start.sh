
sudo yum update -y
sudo yum install nginx -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh

sudo systemctl start nginx
sudo cp /var/www/neighborly.tools/nginx/neighborly.tools.conf /etc/nginx/conf.d/neighborly.tools.conf
cd /tmp
wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
DEBIAN_FRONTEND=noninteractive sudo yum install -y ./epel.rpm
DEBIAN_FRONTEND=noninteractive sudo yum install python2-certbot.noarch -y
DEBIAN_FRONTEND=noninteractive sudo yum install python-certbot-nginx -y
DEBIAN_FRONTEND=noninteractive sudo certbot -n --nginx --email 2015rpro@gmail.com --agree-tos --domain neighborly.tools
sudo systemctl restart nginx
sudo yum install supervisor
sudo groupadd --system supervisor
sudo su 
echo_supervisord_conf > /etc/supervisord.conf
sudo systemctl enable supervisord
sudo systemctl start supervisord.service

sudo supervisorctl reload
sudo systemctl restart nginx