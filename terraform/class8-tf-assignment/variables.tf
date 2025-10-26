variable "region" {
  type    = string
  default = "us-east-1"
}

variable "prefix" {
  default = "tf"
}

variable "project" {
  default = "devops-learning"
}

variable "contact" {
  default = "sathish100685@gmail.com"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_list" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.10.0/24", "10.0.20.0/24"]
}


variable "instance_type" {
  default = "t2.micro"
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
  default     = "devdb"
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
  default     = "devteam"
}