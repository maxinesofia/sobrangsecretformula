resource "aws_eip" "nat" { domain = "vpc" }

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[1].id 
  tags          = merge(var.common_tags, { Name = "${var.lastname}-FinalProject-NAT" })
}