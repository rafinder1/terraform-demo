data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "web" {
    name_prefix = "terraform-launch-template-"
    image_id = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type

    network_interfaces {
      associate_public_ip_address = true
      security_groups = [ aws_security_group.instance_sg.id ]
    }

    user_data = base64encode(<<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "<h1>Witaj z serwera ${hostname -f}</h1>" > /var/www/html/index.html
        EOF
    )

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "web" {
    name = "terraform-asg"
    vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    min_size = var.asg_min_size
    desired_capacity = var.asg_desired_capacity
    max_size = var.asg_max_size

    health_check_type = "ELB"
    health_check_grace_period = 300

    target_group_arns = [ aws_lb_target_group.web.arn ]

    launch_template {
      id = aws_launch_template.web.id
      version = "$Latest"
    }

    lifecycle {
      create_before_destroy = true
    }
  
}