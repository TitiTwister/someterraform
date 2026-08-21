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

resource "outscale_security_group_rule" "tools_step_ca" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id
  rules {
    from_port_range = "443"
    to_port_range   = "443"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.dmz_subnet}", "${var.k8s_subnet}"]
  }
}

# Grafana and Prometheus port redirection from HAPROXY
resource "outscale_security_group_rule" "tools_grafana" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id
  rules {
    from_port_range = "3000"
    to_port_range   = "3000"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "tools_prometheus" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id
  rules {
    from_port_range = "9090"
    to_port_range   = "9090"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "tools_alertmanager" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id
  rules {
    from_port_range = "9093"
    to_port_range   = "9093"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "tools_dns" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id
  rules {
    from_port_range = "53"
    to_port_range   = "53"
    ip_ranges       = ["${var.dmz_subnet}", "${var.k8s_subnet}"]
  }
}


