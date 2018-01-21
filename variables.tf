variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "env" {
  default = "dev"
}

variable "prefix" {
  default = "ooo"
}

variable "domain_name" {
  default = "alibabacloudnews.com"
}

variable "ip_whitelist" {
  default = "80.94.184.10/32"
}
