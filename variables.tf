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
  default     = "10.0.0.0/16"
}

variable "dmz_subnet" {
  description = "DMZ subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "tools_subnet" {
  description = "TOOLS subnet CIDR"
  type        = string
  default     = "10.0.100.0/24"
}

variable "k8s_subnet" {
  description = "Kubernetes nodes subnet CIDR"
  type        = string
  default     = "10.0.8.0/24"
}

variable "allowed_cidr" {
  description = "List of all IP allowed to SSH OpenVPN VM"
  type        = list(string)
}

variable "ovpn_ip" {
  description = "Private ip for OpenVPN VM"
  type        = string
  default     = "10.0.0.254" 
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

variable "medium_vm_type" {
  description = "VM type for medium usage"
  type        = string
  default     = "tinav7.c4r16p2"
}

variable "dmz_vpn_key" {}
variable "server_key" {}

variable "k8s_master_ips" {
  description = "List of private IPs for K8s master VMs"
  type        = list(string)
  default     = ["10.0.8.100", "10.0.8.101", "10.0.8.102"]
}

variable "k8s_worker_ips" {
  description = "List of private IPs for K8s worker VMs"
  type        = list(string)
  default     = ["10.0.8.200", "10.0.8.201", "10.0.8.202"]
}
