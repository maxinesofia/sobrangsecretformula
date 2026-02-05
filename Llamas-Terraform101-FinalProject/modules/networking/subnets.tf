data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  # Updated Naming Convention: lastname-projectname-resource-index
  tags = merge(var.common_tags, { 
    Name = "${var.lastname}-${var.project_name}-PubSub-${count.index}" 
  })
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # Updated Naming Convention: lastname-projectname-resource-index
  tags = merge(var.common_tags, { 
    Name = "${var.lastname}-${var.project_name}-PrivSub-${count.index}" 
  })
}