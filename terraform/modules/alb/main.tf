resource "aws_lb" "app" {
  name               = "app-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_security_group_id]
}

resource "aws_lb_target_group" "frontend" {
  name         = "frontend-tg"
  port         = 3000
  protocol     = "HTTP"
  vpc_id       = var.vpc_id
  target_type  = "ip"

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "backend" {
  name         = "backend-tg"
  port         = 8000
  protocol     = "HTTP"
  vpc_id       = var.vpc_id
  target_type  = "ip"

  health_check {
    path = "/api/health"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
