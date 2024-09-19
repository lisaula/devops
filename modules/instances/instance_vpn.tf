resource "aws_instance" "ec2_vpn" {
  ami                       = var.ami_id_vpn
  instance_type             = var.instance_types_vpn
  subnet_id                 = var.subnet_public_id

  root_block_device {
    volume_type             = var.volume_type
    volume_size             = var.volume_size
  }

  key_name                  = "aws-access"
  tags                      = {
    Name                    = "VPN server"
  }
}
resource "aws_eip" "_" {
  vpc                       = true
}

resource "aws_eip_association" "_" {
  instance_id               = aws_instance.ec2_vpn.id
  allocation_id             = aws_eip._.id
}
