terraform {
  required_version = ">= 0.11.2"
}

provider "alicloud" {
  version = ">= 1.5.3"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "alicloud_ram_account_alias" "alias" {
  account_alias = "frap"
}

resource "alicloud_key_pair" "ellerbrock" {
  key_name   = "ellerbrock"
  public_key = "${file("${path.module}/data/ssh/ellerbrock.pub")}"
}

#
# Data
#

data "alicloud_images" "coreos" {
  most_recent = true
  name_regex  = "^coreos"
  owners      = "system"
}

#
# OSS Buckets
#

resource "alicloud_oss_bucket" "logs" {
  bucket = "logs-${var.env}-${var.prefix}"
  acl    = "private"
}

resource "alicloud_oss_bucket" "www" {
  bucket = "www-${var.env}-${var.prefix}"

  logging {
    target_bucket = "${alicloud_oss_bucket.logs.id}"
    target_prefix = "log/"
  }

  logging_isenable = true
}

#
# VPC
#

resource "alicloud_vpc" "main" {
  name       = "vpc-default"
  cidr_block = "192.168.0.0/16"
}

resource "alicloud_security_group" "sg_default" {
  name        = "sg_default"
  description = "default security group"
  vpc_id      = "${alicloud_vpc.main.id}"
}

#
# Frontend AZ1
#

resource "alicloud_vswitch" "vswitch_frontend_az1" {
  vpc_id            = "${alicloud_vpc.main.id}"
  cidr_block        = "192.168.10.0/24"
  availability_zone = "${var.region}a"
  name              = "vswitch_frontend_az1a"
}

resource "alicloud_vswitch" "vswitch_frontend_az2" {
  vpc_id            = "${alicloud_vpc.main.id}"
  cidr_block        = "192.168.11.0/24"
  availability_zone = "${var.region}b"
  name              = "vswitch_frontend_az1b"
}

#
# Security Group Autoscaling
#

resource "alicloud_security_group" "sg_rancher" {
  name        = "rancher-server"
  description = "Security Group for Rancher Server"
  vpc_id      = "${alicloud_vpc.main.id}"
}

resource "alicloud_security_group_rule" "sgr_rancher_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_rancher.id}"
  cidr_ip           = "${var.ip_whitelist}"
}

resource "alicloud_security_group_rule" "sgr_rancher_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_rancher.id}"
  cidr_ip           = "${var.ip_whitelist}"
}

#
# Autoscaling Group
#

# Availability Zone 1
resource "alicloud_ess_scaling_group" "asg_frontend_az1" {
  min_size         = 1
  max_size         = 2
  removal_policies = ["OldestInstance", "OldestScalingConfiguration"]
  vswitch_id       = "${alicloud_vswitch.vswitch_frontend_az1.id}"
}

resource "alicloud_ess_scaling_configuration" "asgc_frontend_az1" {
  scaling_group_id  = "${alicloud_ess_scaling_group.asg_frontend_az1.id}"
  active            = "true"
  image_id          = "${data.alicloud_images.coreos.images.0.id}"
  instance_type     = "ecs.c4.xlarge"
  key_name          = "ellerbrock"
  security_group_id = "${alicloud_security_group.sg_rancher.id}"
}

# Availability Zone 2
resource "alicloud_ess_scaling_group" "asg_frontend_az2" {
  min_size         = 1
  max_size         = 2
  removal_policies = ["OldestInstance", "OldestScalingConfiguration"]
  vswitch_id       = "${alicloud_vswitch.vswitch_frontend_az2.id}"
}

resource "alicloud_ess_scaling_configuration" "asgc_frontend_az2" {
  scaling_group_id  = "${alicloud_ess_scaling_group.asg_frontend_az2.id}"
  active            = "true"
  image_id          = "${data.alicloud_images.coreos.images.0.id}"
  instance_type     = "ecs.c4.xlarge"
  key_name          = "ellerbrock"
  security_group_id = "${alicloud_security_group.sg_rancher.id}"
}

#
# Backend
#

resource "alicloud_vswitch" "vswitch_backend_az1" {
  vpc_id            = "${alicloud_vpc.main.id}"
  cidr_block        = "192.168.50.0/24"
  availability_zone = "${var.region}a"
  name              = "vswitch_backend_az1a"
}

resource "alicloud_vswitch" "vswitch_backend_az2" {
  vpc_id            = "${alicloud_vpc.main.id}"
  cidr_block        = "192.168.51.0/24"
  availability_zone = "${var.region}b"
  name              = "vswitch_backend_az1b"
}

#
# RDS
#

resource "alicloud_db_instance" "rancher" {
  engine           = "MySQL"
  engine_version   = "5.6"
  instance_storage = "10"
  instance_type    = "rds.mysql.t1.small"
  multi_az         = true

  #    vswitch_id = "vswitch_backend_az1a"
}

resource "alicloud_security_group_rule" "sgr_in_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_default.id}"
  cidr_ip           = "80.94.10.3/32"
}

resource "alicloud_security_group_rule" "sgr_in_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_default.id}"
  cidr_ip           = "80.94.184.10/32"
}

resource "alicloud_security_group" "sg_rancher" {
  name        = "sg-rancher"
  description = "rancher server"
  vpc_id      = "${alicloud_vpc.main.id}"
}

resource "alicloud_security_group_rule" "sgr_in_rancher" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg_rancher.id}"
  cidr_ip           = "80.94.184.10/32"
}

resource "alicloud_dns_record" "test" {
  name        = "${var.domain_name}"
  host_record = "test"
  type        = "CNAME"
  value       = "frapsoft.com"
  ttl         = "600"
}

resource "alicloud_db_instance" "main" {
  engine           = "MySQL"
  engine_version   = "5.6"
  instance_type    = "rds.mysql.t1.small"
  instance_storage = "20"
  vswitch_id       = "${alicloud_vswitch.main.id}"
}

resource "alicloud_db_account" "main" {
  instance_id = "${alicloud_db_instance.main.id}"
  name        = "rdsmin"
  password    = "password-here"
}

resource "alicloud_db_backup_policy" "main" {
  instance_id      = "${alicloud_db_instance.main.id}"
  backup_period    = ["Tuesday", "Thursday", "Saturday"]
  backup_time      = "02:00Z-03:00Z"
  retention_period = 7
  log_backup       = true
}
