# COLD VAULT Security Group

resource "outscale_security_group" "sg_cold_vault" {
  description         = "COLD VAULT security group"
  security_group_name = "${var.project_name}_cold_vault"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_cold_vault"
  }
}

# SSH access from allowed IPs
resource "outscale_security_group_rule" "cold_vault_ssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_cold_vault.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}
