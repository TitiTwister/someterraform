######################################
############### DMZ ##################
######################################

resource "outscale_security_group" "sg_dmz" {
  description         = "DMZ security group"
  security_group_name = "${var.project_name}_dmz"
  net_id              = outscale_net.home_eu.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_dmz"
  }
}

resource "outscale_security_group_rule" "dmz_rule" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_dmz.security_group_id

  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = var.allowed_cidr
  }
}

######################################
############### TOOLS ################
######################################

resource "outscale_security_group" "sg_tools" {
  description         = "Tools security group "
  security_group_name = "${var.project_name}_tools"
  net_id              = outscale_net.home_eu.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_tools"
  }
}

resource "outscale_security_group_rule" "tools_rule_01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_tools.security_group_id

  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.ovpn_ip}/32"]
  }
}



######################################
################ K8S #################
######################################

resource "outscale_security_group" "sg_k8s" {
  description         = "Tools security group "
  security_group_name = "${var.project_name}_k8s"
  net_id              = outscale_net.home_eu.net_id

  tags {
    key   = "Name"
    value = "${var.project_name}_k8s"
  }
}

resource "outscale_security_group_rule" "k8s_rule_01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.sg_k8s.security_group_id

  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    ip_ranges       = ["${var.ovpn_ip}/32"]
  }
}
