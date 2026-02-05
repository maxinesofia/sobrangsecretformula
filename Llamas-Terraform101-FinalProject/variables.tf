variable "lastname" {}
variable "firstname" {}
variable "project_code" {}
variable "region" {}

locals {
  common_tags = {
    Engineer    = "${var.lastname}-${var.firstname}"
    ProjectCode = var.project_code
  }
}