resource "aws_instance" "ec2testserver" {
  ami = "ami-097a2df4ac947655f"
  instance_type = "t2.micro"
  user_data = <<EOF
              #!/bin/bash
              sudo apt update
              sudo apt install nginx -y
              systemctl enable nginx
              systemctl start nginx
              EOF
  key_name= aws_key_pair.web.id
  vpc_security_group_ids=[aws_security_group.ssh-access.id]

  }

resource "aws_key_pair" "web" {
  public_key = file("web.pub")
}

resource "aws_security_group" "ssh-access" {
  name="ssh-access-divya"
  description =" allow ssh access from the internet(divya)"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks= ["0.0.0.0/0"]
  }
}

output publicip {
  value = aws_instance.ec2testserver.public_ip
}
         