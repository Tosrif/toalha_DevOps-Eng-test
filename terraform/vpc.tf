###################
# VPC
###################
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "my_vpc"
  }

}


###################
# SUBNETS
###################
resource "aws_subnet" "my_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.100.1.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my_subnet_a"
  }

}

resource "aws_subnet" "my_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.100.2.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my_subnet_b"
  }

}

resource "aws_subnet" "my_subnet_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.100.3.0/24"
  availability_zone = "ap-southeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "my_subnet_c"
  }

}


##################
# Route Table
##################
resource "aws_route_table" "my_vpc_rtb" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "my_subnet_a_association" {
  subnet_id      = aws_subnet.my_subnet_a.id
  route_table_id = aws_route_table.my_vpc_rtb.id
}

resource "aws_route_table_association" "my_subnet_b_association" {
  subnet_id      = aws_subnet.my_subnet_b.id
  route_table_id = aws_route_table.my_vpc_rtb.id
}

resource "aws_route_table_association" "my_subnet_c_association" {
  subnet_id      = aws_subnet.my_subnet_c.id
  route_table_id = aws_route_table.my_vpc_rtb.id
}


##################
# VPC endpoints
##################
resource "aws_vpc_endpoint" "my_vpc_ecr_dkr_endpoint" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.ap-southeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.my_sg_endpoint.id]
  subnet_ids  = [aws_subnet.my_subnet_a.id, aws_subnet.my_subnet_b.id, aws_subnet.my_subnet_c.id]
}

resource "aws_vpc_endpoint" "my_vpc_ecr_api_endpoint" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.ap-southeast-2.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.my_sg_endpoint.id]
  subnet_ids  = [aws_subnet.my_subnet_a.id, aws_subnet.my_subnet_b.id, aws_subnet.my_subnet_c.id]
}

resource "aws_vpc_endpoint" "my_vpc_s3_endpoint" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.ap-southeast-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.my_vpc_rtb.id]
}



##################
# Security Group
##################
resource "aws_security_group" "my_sg_flask_app" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "my_sg_endpoint" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.my_sg_flask_app.id]
  }
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
}