variable "role_name" {
  type = string
}

variable "secret_arn" {
  type        = string
}

variable "common_tags" {
  type = map(string)
}
