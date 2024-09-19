variable "cluster" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "instance_types" {}
variable "ami_type" {}
variable "size_disk" {}
variable "subnet_ids" {
  type = list(string)
}
