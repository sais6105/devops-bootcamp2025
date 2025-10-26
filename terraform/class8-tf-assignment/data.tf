data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "image-id"
    values = ["ami-0341d95f75f311023"]
  }
  owners = ["amazon"]
}

data "aws_region" "current" {
  name = "us-east-1"
}