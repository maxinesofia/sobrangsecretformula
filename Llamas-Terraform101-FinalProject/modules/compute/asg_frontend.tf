resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.lastname}-frontend-"
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
    tags = merge(var.common_tags, { Name = "${var.lastname}-FrontendHost" })
  }
}