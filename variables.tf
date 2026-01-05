variable "osc_access_key" {
  description = "AK"
  type        = string
}

variable "osc_secret_key" {
  description = "SK"
  type        = string
}

variable "osc_region" {
  description = "Outscale region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "home-vpc"
}

variable "vpc_cidr" {
  description = "Main VPC CIDR"
  type        = string
  default     = "10.111.0.0/16"
}

variable "dmz_subnet" {
  description = "DMZ subnet CIDR"
  type        = string
  default     = "10.111.0.0/24"
}

variable "tools_subnet" {
  description = "TOOLS subnet CIDR"
  type        = string
  default     = "10.111.100.0/24"
}

variable "k8s_subnet" {
  description = "Kubernetes nodes subnet CIDR"
  type        = string
  default     = "10.111.8.0/24"
}

variable "allowed_cidr" {
  description = "List of all IP allowed to SSH OpenVPN VM"
  type        = list
}

variable "ovpn_ip" {
  description = "Private ip for OpenVPN VM"
  type        = string
  default     = "10.111.0.254" 
}

variable "rocky_10_ami" {
  description = "AMI id for rocky 10 image"
  type        = string
  default     = "ami-ebce0925"
}

variable "casual_vm_type" {
  description = "VM type for casual usage"
  type        = string
  default     = "tinav7.c2r8p2"
}

variable "home_dmz_vpn_key" {}
