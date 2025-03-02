resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_security_group" "alb_sg" {
    name_prefix = "alb-sg-"
    description = "Security Group para el Application Load Balancer"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "Permitir tráfico HTTP desde cualquier lugar"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Permitir tráfico HTTPS desde cualquier lugar"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Permitir tráfico de salida"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "alb-security-group"
    }
}
