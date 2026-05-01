
resource "outscale_security_group" "sg_haproxy" {
  description         = "HAPROXY security group"
  security_group_name = "${var.project_name}_haproxy"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_haproxy"
  }
}

resource "outscale_security_group_rule" "haproxy_http" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "80"
    to_port_range   = "80"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}

resource "outscale_security_group_rule" "haproxy_http_alt" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "8080"
    to_port_range   = "8080"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}

resource "outscale_security_group_rule" "haproxy_alertmanager" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "9093"
    to_port_range   = "9093"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}

resource "outscale_security_group_rule" "haproxy_node_exporter" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "9100"
    to_port_range   = "9100"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.prometheus_ip}/32"]
  }
}
