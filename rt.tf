################ DMZ ################

resource "outscale_route_table" "rtb_dmz" {
    net_id = outscale_net.home_eu.net_id
}

resource "outscale_route_table_link" "rtb_dmz_link" {
    subnet_id      = outscale_subnet.dmz_subnet.subnet_id
    route_table_id = outscale_route_table.rtb_dmz.route_table_id
}

resource "outscale_route" "default_route_dmz" {
    destination_ip_range = "0.0.0.0/0"
    gateway_id           = outscale_internet_service.home_eu_igw.internet_service_id
    route_table_id       = outscale_route_table.rtb_dmz.route_table_id
}

############### TOOLS ###############

resource "outscale_route_table" "rtb_tools" {
    net_id = outscale_net.home_eu.net_id
}

resource "outscale_route_table_link" "rtb_tools_link" {
    subnet_id      = outscale_subnet.tools_subnet.subnet_id
    route_table_id = outscale_route_table.rtb_tools.route_table_id
}

resource "outscale_route" "default_nat_tools" {
    destination_ip_range = "0.0.0.0/0"
    nat_service_id       = outscale_nat_service.home_eu_natgw.nat_service_id
    route_table_id       = outscale_route_table.rtb_tools.route_table_id
}

################ K8S ################

resource "outscale_route_table" "rtb_k8s" {
    net_id = outscale_net.home_eu.net_id
}

resource "outscale_route_table_link" "rtb_k8s_link" {
    subnet_id      = outscale_subnet.k8s_subnet.subnet_id
    route_table_id = outscale_route_table.rtb_k8s.route_table_id
}

resource "outscale_route" "default_nat_k8s" {
    destination_ip_range = "0.0.0.0/0"
    nat_service_id       = outscale_nat_service.home_eu_natgw.nat_service_id
    route_table_id       = outscale_route_table.rtb_k8s.route_table_id
}
