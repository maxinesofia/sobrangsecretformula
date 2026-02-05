data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.lastname}-frontend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  
  vpc_security_group_ids = [var.frontend_sg_id]
  user_data              = filebase64("${path.root}/scripts/frontend_userdata.sh")

  # Requirement: Enables 1-minute metrics
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, { 
      Name = "${var.lastname}-FrontendHost" 
    })
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                = "${var.lastname}-FrontendASG"
  vpc_zone_identifier = var.public_subnets
  target_group_arns   = [aws_lb_target_group.frontend_tg.arn]
  health_check_type   = "ELB"
  
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
}