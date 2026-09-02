
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

resource "outscale_security_group_rule" "haproxy_https" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "443"
    to_port_range   = "443"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}

resource "outscale_security_group_rule" "haproxy_sshssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "2222"
    to_port_range   = "2222"
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
    ip_ranges       = ["${var.prometheus_ip[0]}/32", "${var.prometheus_ip[1]}/32"]
  }
}

resource "outscale_security_group_rule" "haproxy_kapi" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "6443"
    to_port_range   = "6443"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.dmz_subnet}", "${var.k8s_subnet}"]
  }
}

resource "outscale_security_group_rule" "haproxy_postgre" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_haproxy.security_group_id
  rules {
    from_port_range = "5432"
    to_port_range   = "5433"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.k8s_subnet}"]
  }
}

