# --------------------------------------------------------------------------------
# Networking Infrastructure
# --------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = var.tags
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_subnet_cidr

  tags = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}

# --------------------------------------------------------------------------------
# Networking Routing
# --------------------------------------------------------------------------------
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "main_rt_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# --------------------------------------------------------------------------------
# Security
# --------------------------------------------------------------------------------
resource "aws_security_group" "web" {
  name_prefix = "dvwa"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.listen_port
    to_port     = var.listen_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# --------------------------------------------------------------------------------
# EC2 instance
# --------------------------------------------------------------------------------

resource "aws_key_pair" "web" {
  count      = length(var.public_key) > 0 ? 1 : 0
  key_name   = "dvwa-key"
  public_key = var.public_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    listen_port = var.listen_port
    php_version = var.php_version
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = length(var.public_key) > 0 ? aws_key_pair.web[0].key_name : null

  user_data = data.template_file.user_data.rendered

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = aws_subnet.main.id

  tags = var.tags
}
