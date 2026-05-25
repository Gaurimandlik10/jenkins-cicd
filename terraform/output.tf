output "ec2_public_ip"{
    value = aws_instance.jenkinsdemo.public_ip
}