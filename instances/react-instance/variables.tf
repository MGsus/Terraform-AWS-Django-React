variable "vpc_id" {
  description = "VPC ID number"
  type        = string
}

variable "key_name" {
  default = "front-key"
}


variable "subnet_id" {
  description = "subnet id number"
  type        = string
}
