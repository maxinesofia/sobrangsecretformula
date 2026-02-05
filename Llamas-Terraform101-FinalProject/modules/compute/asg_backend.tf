resource "aws_launch_template" "backend" {
  name_prefix   = "${var.lastname}-backend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  
  vpc_security_group_ids = [var.backend_sg_id]
  user_data              = filebase64("${path.root}/scripts/backend_userdata.sh")

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, { 
      Name = "${var.lastname}-BackendHost" 
    })
  }
}

resource "aws_autoscaling_group" "backend" {
  name                = "${var.lastname}-BackendASG"
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [aws_lb_target_group.backend_tg.arn]
  
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
}