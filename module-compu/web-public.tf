


# load balancer





resource "aws_lb" "WebTierLoadBalancer" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserversg.id]
 
  subnets =  var.public_subnets

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}


resource "aws_security_group" "webserversg" {
  name        = "WebserverSecurityGroup"
  description = "Web server security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  # https
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  # ssh
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.SSHLocation]
  }
}



resource "aws_lb_listener" "ws" {
  load_balancer_arn = aws_lb.WebTierLoadBalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:eu-west-3:437454289258:certificate/48362582-3117-47c6-b5c8-1e3760520f7d"
 //le he metido directamente el certificate, sin crear listener certificate..
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ws.arn
  }
}


resource "aws_lb_target_group" "ws" {
  name        = "target group"
  target_type = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  deregistration_delay = "20"
  
  health_check {
      enabled             = true
      interval            = 10
      path                = "/health"
      matcher             = "200-299"
      healthy_threshold   = 2
      unhealthy_threshold = 5
      timeout             = 5
  }

  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "30"
  }
}


# AUTOSCALING




resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "ws" {
  name                      = "ASC ws"
  max_size                  = 2
  min_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.webserverCapacity
  # "WebserverCapacity": {
  #           "Default": "2",
  #           "Description": "The initial nuber of Webserver instances",
  #           "Type": "Number",
  #           "MinValue": "1",
  #           "MaxValue": "6",
  #           "ConstraintDescription": "must be between 1 and 6 EC2 instances."
  #       },
  force_delete              = true
  placement_group           = aws_placement_group.test.id
  launch_template      = aws_launch_template.ws.id
  vpc_zone_identifier       = var.public_subnets

  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = jsonencode({
      foo = "bar"
    })

    notification_target_arn = "arnawssqs:us-east-1444455556666queue1*"
    role_arn                = "arnawsiam:123456789012role/S3Access"
  }

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}


resource "aws_autoscaling_policy" "ws" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name
}


resource "aws_launch_template" "ws" {
  name = "foo"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  elastic_gpu_specifications {
    type = "test"
  }

  elastic_inference_accelerator {
    type = "eia1.medium"
  }

  iam_instance_profile {
    name = "test"
  }

  image_id = "ami-test"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.micro"

  kernel_id = "test"

  key_name = "test"

  license_specification {
    license_configuration_arn = "arnawslicense-manager:eu-west-1123456789012license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-west-2a"
  }

  ram_disk_id = "test"

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh")

  }