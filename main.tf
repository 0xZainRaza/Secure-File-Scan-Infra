
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# setting up the VPC 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#creating a internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


#Creating a route table

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  #This will send all the ipv4 traffic where even it routes 
    gateway_id = aws_internet_gateway.gw.id
  }

  

  tags = {
    Name = "example"
  }
}


# Setting up the Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # This basically sets your data in two different region if one data center
                                   # is down you are still good to go 

  tags = {
    Name = "Subnet"
  }
}

# Associating the subnet to the route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.example.id
}


#Creating Security Group baciscally a ACL

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS Web traffic from port 443, HTTP traffic from port 80, and SSH traffic from port 22 from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


# Creating a network interface


resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.main.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_tls.id]

  
}


# Assiging a elastic ip

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.test.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_instance.foo , aws_internet_gateway.gw ]
}

# Deploy a EC2 Ubuntu

resource "aws_instance" "foo" {
  ami           = "ami-04b70fa74e45c3917" # us-west-2
  instance_type = "t2.micro"

  availability_zone = "us-east-1a"
  key_name = "test-key"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.test.id

  }

  user_data = <<-EOF
                #!/bin/bash
    
                sudo apt-get update
                sudo apt-get install -y git docker.io
    
                # Clone the Git repository
                git clone https://github.com/0xZainRaza/Secure-File-Scan /home/ubuntu/Secure-File-Scan
    
                # Change directory into the cloned repository
                cd /home/ubuntu/Secure-File-Scan
    
                # Build the Docker image
                sudo docker build -t secure_file_scan .
    
                # Run the Docker container
                sudo docker run -d -p 443:443 --name secure_file_scan_container secure_file_scan
                 EOF
      tags = {
        Name = "Web-server"
      }
}


 # Output the server's public IP address
output "server_public_ip" {
  value = aws_instance.foo.public_ip
}
