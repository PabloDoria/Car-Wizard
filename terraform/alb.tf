resource "aws_lb" "alb" {
    name               = "car-wizard-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = [aws_subnet.subnet.id]
}
