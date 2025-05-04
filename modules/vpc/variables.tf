variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "cidr_public_subnet" {
  type = list(string)
}

variable "cidr_private_subnet" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}
variable "common_tags" {
  type = map(string)
}
