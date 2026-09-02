# K8s Security Group

resource "outscale_security_group" "sg_k8s" {
  description         = "Kubernetes nodes security group"
  security_group_name = "${var.project_name}_k8s"
  net_id              = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_k8s"
  }
}

# SSH from VPN only
resource "outscale_security_group_rule" "k8s_ssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.ovpn_ip}/32"]
  }
}

resource "outscale_security_group_rule" "k8s_node_exporter" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "9100"
    to_port_range   = "9100"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.prometheus_ip[0]}/32", "${var.prometheus_ip[1]}/32"]
  }
}

resource "outscale_security_group_rule" "k8s_kapi" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "6443"
    to_port_range   = "6443"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "postgresql_postgre" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "5432"
    to_port_range   = "5433"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "postgresql_patroni" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "8008"
    to_port_range   = "8008"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}
resource "outscale_security_group_rule" "postgresql_exporter" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "9187"
    to_port_range   = "9187"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.prometheus_ip[0]}/32", "${var.prometheus_ip[1]}/32"]
  }
}

resource "outscale_security_group_rule" "k8s_http" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "80"
    to_port_range   = "80"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "k8s_https" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "443"
    to_port_range   = "443"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}

resource "outscale_security_group_rule" "k8s_nodeports" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id
  rules {
    from_port_range = "30800"
    to_port_range   = "32767"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.haproxy_ip}/32"]
  }
}
