variable "ami" {
  description = "OS Image code"
  default     = "ami-0a91cd140a1fc148a"
}

variable "key_name" {
  default = "back-key"
}

variable "instance_type" {
  description = "Backend instance type"
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "vpc id number"
  type        = string
}

variable "subnet_id" {
  description = "subnet id number"
  type        = string
}

