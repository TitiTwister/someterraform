resource "outscale_net" "home_eu" {
  ip_range = var.vpc_cidr
  tags {
    key   = "Name"
    value = var.project_name
  }
}

resource "outscale_subnet" "dmz_subnet" {
  net_id   = outscale_net.home_eu.net_id
  ip_range = var.dmz_subnet
  tags {
    key   = "Name"
    value = "${var.project_name}_dmz"
  }
}

resource "outscale_subnet" "tools_subnet" {
  net_id   = outscale_net.home_eu.net_id
  ip_range = var.tools_subnet
  tags {
    key   = "Name"
    value = "${var.project_name}_tools"
  }
}

resource "outscale_subnet" "k8s_subnet" {
  net_id   = outscale_net.home_eu.net_id
  ip_range = var.k8s_subnet
  tags {
    key   = "Name"
    value = "${var.project_name}_k8s"
  }
}
