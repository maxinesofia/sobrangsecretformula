#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# 1. Self-Discovery (IMDSv2) - Not Hardcoded
# The server asks AWS: "Who am I?"
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
MY_HOSTNAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-hostname)

# 2. Dynamic Backend Discovery - Not Hardcoded
# We use the variable injected by Terraform to find the backend
BACKEND_DATA=$(curl -s http://${nlb_address})

# 3. Create the Page
echo "<h1>Frontend Server: $MY_HOSTNAME</h1>" > /var/www/html/index.html
echo "<h3>Live Backend Metadata:</h3>" >> /var/www/html/index.html
echo "<pre>$BACKEND_DATA</pre>" >> /var/www/html/index.html