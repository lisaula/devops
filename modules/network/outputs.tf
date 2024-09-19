output "vpc" {
  value                     = aws_vpc.main
}
output "cidr_block" {
  value                     = aws_vpc.main.cidr_block
}
output "private_subnet_1a" {
  value                     = aws_subnet.private-us-east-1a
}
output "private_subnet_1b" {
  value                     = aws_subnet.private-us-east-1b
}
output "private_subnet_1c" {
  value                     = aws_subnet.private-us-east-1c
}
output "public_subnet_1a" {
  value                     = aws_subnet.public-us-east-1a
}
output "public_subnet_1b" {
  value                     = aws_subnet.public-us-east-1b
}
output "public_subnet_1c" {
  value                     = aws_subnet.public-us-east-1c
}
