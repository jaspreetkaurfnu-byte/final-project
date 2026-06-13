provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "web_sg" {
  name = "cse632-web-sg"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-0d1b5a8c13042c939"
  instance_type = "t3.micro"

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx

              cat > /var/www/html/index.html <<HTML
              <html>
              <head><title>CSE632 Final Project</title></head>
              <body>
              <h1>Welcome to My Cloud Website</h1>
              <p>Created by Jaspreet Kaur</p>
              <p>NGINX deployed using Terraform</p>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name = "cse632-final-project"
  }
}
