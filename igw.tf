resource "outscale_internet_service" "home_eu_igw" {
  tags {
    key   = "Name"
    value = "${var.project_name}_igw"
  }
}

resource "outscale_internet_service_link" "home_eu_igw_link" {
    net_id              = outscale_net.home_eu.net_id
    internet_service_id = outscale_internet_service.home_eu_igw.id
}
