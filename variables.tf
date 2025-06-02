variable "region" {
    description = "Region AWS, w którym zostanie utworzona infrastruktura"
    type = string
    default = "us-east-1"
}

variable "instance_type" {
    description = "Typ instancji EC2"
    type = string
    default = "t2.micro"
}

variable "asg_min_size" {
    description = "Minimalna liczba instancji w Auto Scaling Group"
    type = number
    default = 2  
}

variable "asg_desired_capacity" {
    description = "Pożądana liczba instancji w Auto Scaling Group"
    type = number
    default = 2
}

variable "asg_max_size" {
    description = "Maksymalna liczba instancji w Auto Scaling Group"
    type = number
    default = 4
}

variable "vpc_cidr" {
    description = "Bloc CIRD dla VPC"
    type = string
    default = "10.0.0.0/16"
}