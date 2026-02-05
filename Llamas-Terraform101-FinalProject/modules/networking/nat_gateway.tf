# 1. Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  # Best Practice: Tag your EIP so you know what it's for
  tags = merge(var.common_tags, { 
    Name = "${var.lastname}-${var.project_name}-NAT-EIP" 
  })
}

# 2. NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[1].id # Deployed in your second public subnet
  
  # Updated Naming Convention
  tags = merge(var.common_tags, { 
    Name = "${var.lastname}-${var.project_name}-NAT" 
  })
}