module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6"       # current stable version

  name = var.instance_name

  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true

  tags = {
    Project = "Jenkins-Terraform"
    Owner   = "Govardhan"
  }
}
