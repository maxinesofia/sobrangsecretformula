resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.lastname}-${var.project_name}-frontend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  
  vpc_security_group_ids = [var.frontend_sg_id]

  # DYNAMIC FIX: Passes the NLB DNS into the script variable 'nlb_address'
  user_data = base64encode(templatefile("${path.root}/scripts/frontend_userdata.sh", {
    nlb_address = aws_lb.backend.dns_name
  }))

  monitoring {
    enabled = true
  }

tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, { Name = "${var.lastname}-${var.project_name}-FrontendHost" })
  }
}
# This tells AWS how to manage the servers created from your blueprint
resource "aws_autoscaling_group" "frontend" {
  # Here is your new dynamic name!
  name                = "${var.lastname}-${var.project_name}-FrontendASG"
  
  vpc_zone_identifier = var.public_subnets
  target_group_arns   = [aws_lb_target_group.frontend_tg.arn]
  health_check_type   = "ELB"
  
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  # This links the Manager to your Blueprint
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
}