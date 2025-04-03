# 0. Setup
apt update && apt upgrade -y
apt install sudo adduser iputils-ping netcat-openbsd net-tools vim curl -y

adduser robert
usermod -aG sudo robert # add the new user to the sudo group since we'll still probably need to run admin commands
groups robert # check if robert is in sudo group
su robert # switch to newly created user

# 1. Lookup the Public IP of cloudflare.com
nslookup cloudflare.com

# 2. Map IP address 8.8.8.8 to hostname google-dns
ping google-dns 
echo "8.8.8.8 google-dns" | sudo tee -a /etc/hosts
cat /etc/hosts
ping google-dns

# 3. Check if the DNS Port is Open for google-dns
nc -zv google-dns 53

# 4. Modify the System to Use Google’s Public DNS
# 4.1 Change the nameserver to 8.8.8.8 instead of the default local configuration.
cat /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
cat /etc/resolv.conf
# 4.2 Perform another public IP lookup for cloudflare.com and compare the results.
nslookup cloudflare.com

# 5. Install and verify that Nginx service is running
sudo apt install nginx -y
sudo service nginx start
service nginx status
# 6. Find the Listening Port for Nginx
netstat -tulnp | grep nginx

# BONUS
# 7. Change the Nginx Listening port to 8080
sudo vim /etc/nginx/sites-available/default # and I edit the port there
# I restart nginx
sudo service nginx stop
sudo service nginx start
# I check the port again
netstat -tulnp | grep nginx

# 8. Modify the default HTML page title from: "Welcome to nginx!" → "I have completed the Linux part of the DevOps internship project"
sudo vim /var/www/html/index.nginx-debian.html # and I edit the title there
curl http://localhost:8080 # fetch the page to check if it changed