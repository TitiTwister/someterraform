resource "outscale_nat_service" "main_vpc_natgw" {
  subnet_id    = outscale_subnet.dmz_subnet.subnet_id
  public_ip_id = outscale_public_ip.nat_public_ip.public_ip_id
  tags {
    key   = "Name"
    value = "${var.project_name}_natgw"
  }
}

resource "outscale_public_ip" "nat_public_ip" {
  tags {
    key   = "Name"
    value = "${var.project_name}_natgw"
  }
}
