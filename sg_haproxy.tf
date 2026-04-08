
resource "outscale_security_group" "sg_haproxy" {
  description         = "HAPROXY security group"
  security_group_name = "${var.project_name}_haproxy"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_haproxy"
  }
}

resource "outscale_security_group_rule" "haproxy_ssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}
