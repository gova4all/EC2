##Get existing VPC by Name tag##
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["My_VPC"]
  }
}
##Get all subnets in that VPC##
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}
##Get an existing Security Group##

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["Public_Subent_01"]
  }
}
##Get an existing Security Group##
data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  vpc_id = data.aws_vpc.existing.id
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.2.0"

  name          = "my-ec2"
  instance_type = "t2.micro"
  #ami           = "ami-0c55b159cbfafe1f0"

  #subnet_id              = data.aws_subnet.public_1.id
  #vpc_security_group_ids = [data.aws_security_group.default.id]
}

