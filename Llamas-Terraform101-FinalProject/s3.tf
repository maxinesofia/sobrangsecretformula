resource "aws_s3_bucket" "terraform_state" {
  bucket = "${lower(var.lastname)}-finalproject-terraform-state"

  lifecycle {
    prevent_destroy = true # Protects your state during a 'terraform destroy'
  }

  tags = merge(local.common_tags, {
    Name = "${var.lastname}-State-Bucket"
  })
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}