


resource "aws_security_group" "app_sg" {
  name_prefix = "jenkins_app"         
  vpc_id      = var.aws_default_vpc

  ingress {
    from_port   = 22 
    to_port     = 22
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
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port = 8080 
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


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
  subnet_id              = var.aws_default_public_subnet   
  # Enable protection against accidental termination
  disable_api_termination = false
  root_block_device {
    volume_size           = 20    
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
