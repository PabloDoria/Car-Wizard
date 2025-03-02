resource "aws_lb" "alb" {
    name               = "car-wizard-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]  # <- Agregar ambas subnetsss

    tags = {
        Name = "car-wizard-alb"
    }
}

resource "aws_lb_target_group" "alb_target" {
    name        = "car-wizard-tg"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.vpc.id
    target_type = "ip"
}
