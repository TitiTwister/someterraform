
resource "outscale_vm" "vm_prom_1" {

  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo    = var.server_key

  primary_nic  {
      nic_id = outscale_nic.prom_1_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-prom-1
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_prom_1"
  }
}

resource "outscale_nic" "prom_1_nic" {

  subnet_id          = outscale_subnet.tools_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_tools.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.prometheus_ip[0]
  }
}

resource "outscale_volume" "prom_1_data" {
  subregion_name = "${var.osc_region}a"
  size           = var.prom_volume_size
  volume_type    = "io1"
  iops           = var.prom_volume_iops

  tags {
    key   = "Name"
    value = "${var.project_name}_prom_1_data"
  }
}

resource "outscale_volume_link" "prom_1_volume_link" {
  device_name = "/dev/xvdb"
  volume_id   = outscale_volume.prom_1_data.volume_id
  vm_id       = outscale_vm.vm_prom_1.vm_id
}



resource "outscale_vm" "vm_prom_2" {

  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo    = var.server_key

  primary_nic  {
      nic_id = outscale_nic.prom_2_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-prom-2
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_prom_2"
  }
}

resource "outscale_nic" "prom_2_nic" {

  subnet_id          = outscale_subnet.tools_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_tools.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.prometheus_ip[1]
  }
}

resource "outscale_volume" "prom_2_data" {
  subregion_name = "${var.osc_region}a"
  size           = var.prom_volume_size
  volume_type    = "io1"
  iops           = var.prom_volume_iops

  tags {
    key   = "Name"
    value = "${var.project_name}_prom_2_data"
  }
}

resource "outscale_volume_link" "prom_2_volume_link" {
  device_name = "/dev/xvdb"
  volume_id   = outscale_volume.prom_2_data.volume_id
  vm_id       = outscale_vm.vm_prom_2.vm_id
}

