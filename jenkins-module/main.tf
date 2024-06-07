
resource "aws_vpc" "infra_vpc" {
  cidr_block = var.cidr_name
  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = local.no_of_subnets
  cidr_block              = cidrsubnet(aws_vpc.infra_vpc.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.infra_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "infra-public_subnet-${aws_vpc.infra_vpc.id}-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = local.no_of_subnets
  cidr_block        = cidrsubnet(aws_vpc.infra_vpc.cidr_block, 8, (count.index + local.no_of_subnets))
  vpc_id            = aws_vpc.infra_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "infra-private_subnet-${aws_vpc.infra_vpc.id}-${count.index + 1}"
  }
}


resource "aws_internet_gateway" "infra_igw" {
  vpc_id = aws_vpc.infra_vpc.id
}

data "aws_availability_zones" "available" {
  state = "available"
}
output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.infra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra_igw.id
  }
  tags = {
    Name = "infra-public_route_table-${aws_vpc.infra_vpc.id}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.infra_vpc.id
  tags = {
    Name = "infra-private_route_table-${aws_vpc.infra_vpc.id}"
  }
}




locals {
  no_of_subnets      = min(3, length(data.aws_availability_zones.available.names))
  public_subnet_ids  = aws_subnet.public_subnet.*.id
  private_subnet_ids = aws_subnet.private_subnet.*.id
  timestamp          = formatdate("YYYY-MM-DDTHH-MM-SS", timestamp())
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(local.public_subnet_ids)
  subnet_id      = local.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(local.private_subnet_ids)
  subnet_id      = local.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "app_sg" {
  name_prefix = "jenkins_app"
  vpc_id      = aws_vpc.infra_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   from_port   = 8080
  #   to_port     = 8080
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-jenkins-sg-${timestamp()}"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                    = var.my_ami
  instance_type          = "t2.micro"
  key_name               = "ec2"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = local.public_subnet_ids[0]
  # Enable protection against accidental termination
  disable_api_termination = false
  user_data               = <<-EOF
    #!/bin/bash

    sudo usermod -a -G docker jenkins
    sudo tee /etc/jenkins.env > /dev/null <<EOF1
    DOCKER_USERNAME=${var.docker_hub_username}
    DOCKER_PASSWORD=${var.docker_hub_password}
    JENKINS_ADMIN_USER_PASSWORD=${var.jenkins_admin_user_password}
    JENKINS_ADMIN_USERNAME=${var.jenkins_admin_username}
    GIT_USERNAME=${var.git_hub_username}
    GIT_PASSWORD=${var.git_hub_password}
    EOF1

    sudo mkdir -p /var/lib/jenkins/init.groovy.d
    sudo mkdir -p /var/lib/jenkins/dsl_scripts
    sudo cp /home/ubuntu/admin-user.groovy /var/lib/jenkins/init.groovy.d/
    sudo cp /home/ubuntu/plugins.groovy /var/lib/jenkins/init.groovy.d/
    sudo cp /home/ubuntu/docker_credential.groovy /var/lib/jenkins/init.groovy.d/
    # sudo cp /home/ubuntu/seed_job.groovy /var/lib/jenkins/init.groovy.d/
    sudo cp /home/ubuntu/job_dsl_script.groovy /var/lib/jenkins/dsl_scripts/
    sudo systemctl enable jenkins

    sudo systemctl restart jenkins
    echo "
    ${var.domain_name} {
        reverse_proxy localhost:8080
    }" | sudo tee /etc/caddy/Caddyfile >/dev/null

    # Restart Caddy
    sudo systemctl restart caddy
  EOF
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "jenkins-instance-${timestamp()}"
  }
}
data "aws_eip" "existing_eip" {
  public_ip = var.aws_elastic_ip
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins_instance.id
  allocation_id = data.aws_eip.existing_eip.id
}

output "eip_allocation_id" {
  value = data.aws_eip.existing_eip.id
}
