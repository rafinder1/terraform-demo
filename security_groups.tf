resource "aws_security_group" "lb_sg" {
    name = "terraform-lb-sg"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_security_group" "instance_sg" {
    name = "terraform-instance-sg"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.lb_sg.id ]
        description = "Allow HTTP from Load Balancer"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "Allow all outbound traffic"
    }
}