


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.2.0"

  name          = "my-ec2"
  instance_type = "t2.micro"
  #ami           = "ami-0c55b159cbfafe1f0"

  #subnet_id              = data.aws_subnet.public_1.id
  #vpc_security_group_ids = [data.aws_security_group.default.id]
}

