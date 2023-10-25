data "aws_vpc" "default" {
  id = "vpc-0d7db10de34e56a33"
}
resource "aws_security_group" "mod2_SG" {
  name        = "allow mod2 to apache server"
  description = "Allow port 80 access for apache server"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    }
    , {
      description = "ssh from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
  }]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "mod2-deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqOn/5iMtuWOlU71A4ySN55AFUyRCxkqvC0V/tM+m0Wpjvc8hfFWFsDYVLRGQtfWw74lIfm7YxBx97pGpKNqn/jGWxDgFN19N4zzV3iGQ2O7rWLX6X7gsbWiIT5TNS07wqg+INrMmYyHGdUIR5xkbGKf6WEo4ZfTW+8XNV/fhkDahXnAaASEedZfBJpLbeK9wvwUB2iKoF3C7Q1IAa5b3ZMbA0ChtRRY5qVF1zB50Il/v5imcyjmkPWfMIXn7N9oJjZyi+HY1XmO+nTdNxpmCUBn5uNHVN9nkWQlVId2mPjnT3KKtLiT4oG727x24biAZzuPvDf+lnFqXQ3p4VXaNGqmGwYiO2lECGmMxCxLNr9S3vPq2wM2GfCCtA4KB+FiSDDsXJP5jCG1pfv4n9QhptlO5J7qSF8/xKaXsvnk+1gq62PVW5WS60vPb3pvEn5ARE0AxKZBKCgtRCde2fLuVI2w7WyXku/LXYIKHX0pKV1a2M7dZH+M2CB1mI0ldeMDE= sambasivam.k@gmail.com"
}
data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_instance" "mod2-ec2" {  
  ami                    = "ami-002843b0a9e09324a"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.mod2_SG.id]
  #user_data              = data.template_file.user_data.renderedassociate_public_ip_address
  user_data = <<-UD
    #!bin/sh
    sudo apt-get update 
    sudo apt-get install nginx -y
    sudo systemctl status nginx
    sudo systemctl start nginx
    sudo chown -R ubuntu:ubuntu /var/www/html
    sudo echo "<html><body><h1>Hello from Module 2 at instance id `curl http://169.254.169.254/latest/meta-data/instance-id`</h1></body></html>" >> /var/www/html/index.nginx-debian.html
  UD
  tags = {
    Name = "Mod2-EC2"
  }
}