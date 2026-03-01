# Tools Security Group

resource "outscale_security_group" "sg_tools" {
  description         = "Tools security group"
  security_group_name = "${var.project_name}_tools"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_tools"
  }
}

# SSH from VPN only
resource "outscale_security_group_rule" "tools_ssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.ovpn_ip}/32"]
  }
}
