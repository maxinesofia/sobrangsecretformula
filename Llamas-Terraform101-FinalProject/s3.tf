resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${lower(var.lastname)}-finalproject-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
  
  tags = merge(local.common_tags, {
    Name = "${var.lastname}-State-Bucket"
  })
}