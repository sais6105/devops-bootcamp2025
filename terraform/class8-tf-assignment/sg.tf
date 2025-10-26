resource "aws_security_group" "sg_web_public" {

  description = "SSH Allowed to Public ec2 from Anywhere"
  name        = "${local.prefix}-public-ssh-access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-private" })
  )

}



resource "aws_security_group" "sg_app_private" {

  description = "SSH allowed only from the VPC "
  name        = "${local.prefix}-private-ssh-access"
  vpc_id      = aws_vpc.main.id

  ingress {

    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks     = [var.vpc_cidr]
#    security_groups = [aws_security_group.sg_web_public.id]
  }


  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-private" })
  )
}



resource "aws_security_group" "sg_rds" {

  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = [aws_subnet.private_subnet1.cidr_block]
    #cidr_blocks = [aws_subnet.private_subnet1.cidr_block,aws_subnet.private_subnet2.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-rds-sg" })
  )
}