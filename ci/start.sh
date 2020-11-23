
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo cp /var/www/neighborly.tools/nginx/neighborly.tools.conf /etc/nginx/conf.d/neighborly.tools.conf
cd /tmp
wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
DEBIAN_FRONTEND=noninteractive sudo yum install -y ./epel.rpm
DEBIAN_FRONTEND=noninteractive sudo yum install python2-certbot.noarch -y
DEBIAN_FRONTEND=noninteractive sudo yum install python-certbot-nginx -y
DEBIAN_FRONTEND=noninteractive sudo certbot -n --nginx --email 2015rpro@gmail.com --agree-tos --domain neighborly.tools