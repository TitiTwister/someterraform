resource "outscale_internet_service" "main_vpc_igw" {
  tags {
    key   = "Name"
    value = "${var.project_name}_igw"
  }
}

resource "outscale_internet_service_link" "main_vpc_igw_link" {
    net_id              = outscale_net.main_vpc.net_id
    internet_service_id = outscale_internet_service.main_vpc_igw.id
}