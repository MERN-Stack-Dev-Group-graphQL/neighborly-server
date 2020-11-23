
tar xzf /home/ec2-user/neighborly-server.tar.gz -C /var/www/neighborly.tools/neighborly-server
sudo yum update -y
sudo amazon-linux-extras install nginx -y
sudo systemctl start nginx
sudo cp /var/www/neighborly.tools/neighborly-server/nginx/neighborly.tools.conf /etc/nginx/conf.d/neighborly.tools.conf
cd /tmp
wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel.rpm
sudo yum install python2-certbot.noarch
sudo yum install python-certbot-nginx
DEBIAN_FRONTEND=noninteractive sudo certbot --nginx