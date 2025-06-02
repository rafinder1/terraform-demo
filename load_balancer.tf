resource "aws_lb_target_group" "web" {
    name = "terraform-lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id

    health_check {
      path = "/"
      protocol = "HTTP"
      port = "80"
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      interval = 30
      matcher = "200"
    }
}

resource "aws_lb" "web" {
    name = "terraform-alb"
    security_groups = [ aws_security_group.lb_sg.id ]
    subnets = [ aws_subnet.public_1.id, aws_subnet.public_2.id ]
}

resource "aws_lb_listener" "web" {
    load_balancer_arn = aws_lb.web.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.web.arn
    }
}