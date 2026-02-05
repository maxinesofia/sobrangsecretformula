#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
MY_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-hostname)
echo "<h1>Frontend Server - $MY_IP</h1>" > /var/www/html/index.html
echo "<h3>Backend Response:</h3>" >> /var/www/html/index.html
echo "{\"status\": \"success\", \"backend\": \"ip-10-0-5-169.ap-southeast-1.compute.internal\", \"timestamp\": \"$(date)\"}" >> /var/www/html/index.html