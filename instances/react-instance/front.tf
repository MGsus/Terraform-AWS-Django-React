resource "tls_private_key" "front-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "front-key" {
  key_name   = var.key_name
  public_key = tls_private_key.front-key.public_key_openssh
}


resource "aws_instance" "front-instance" {
  ami                    = "ami-0a91cd140a1fc148a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.frontend.id]
  key_name               = aws_key_pair.front-key.key_name
  subnet_id              = var.subnet_id

  provisioner "file" {
    source      = "instances/react-instance/hello-world/"
    destination = "/home/ubuntu"
  }

  connection {
    user        = "ubuntu"
    private_key = tls_private_key.front-key.private_key_pem
    host        = self.public_ip
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo snap install node --classic
    cd /home/ubuntu
    npm install
    nohup sudo npm start &
  EOF

  tags = {
    Name = "frontend-instance"
  }
}

resource "aws_security_group" "frontend" {
  name   = "front_security_group"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "frontend-ingress"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh-ingress"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "frontend-egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "front_sg"
  }
}
