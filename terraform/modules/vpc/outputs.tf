output "vpc_id" {
  value = aws_vpc.oleg_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_1.id]
}


output "private_subnet_ids" {
  value = [aws_subnet.private_1.id]
}
