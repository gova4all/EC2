variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair"
  type        = string
}

variable "instance_name" {
  default = "Jenkins-TF-EC2"
}
