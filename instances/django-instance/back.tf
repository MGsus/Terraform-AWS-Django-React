resource "tls_private_key" "back-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "back-key" {
  key_name   = var.key_name
  public_key = tls_private_key.back-key.public_key_openssh
}

resource "aws_instance" "backend-instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.back-key.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]
  subnet_id              = var.subnet_id

  provisioner "file" {
    source      = "instances/django-instance/hello/"
    destination = "/home/ubuntu"
  }

  connection {
    user        = "ubuntu"
    private_key = tls_private_key.back-key.private_key_pem
    host        = self.public_ip
  }

  user_data = <<-EOF
    #!/bin/bash
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    export PATH=LOCAL_PATH:$PATH
    pip install Django
    cd /home/ubuntu
    python3 manage.py migrate
    nohup python3 manage.py runserver 0.0.0.0:8000 &
  EOF

  tags = {
    Name = "backend-instance"
  }
}

resource "aws_security_group" "backend" {
  name   = "back_security_group"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "backend-ingress"
    from_port   = 8000
    protocol    = "tcp"
    to_port     = 8000
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
    description = "backend-egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  tags = {
    Name = "back_sg"
  }

}
