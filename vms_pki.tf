##########################
#       COLD VAULT       #
#########################

resource "outscale_vm" "vm_cold_vault" {
  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo       = var.dmz_vpn_key
  state           = "stopped"
  primary_nic  {
      nic_id = outscale_nic.cold_vault_nic.nic_id
      device_number = "0"
      }

  user_data                = base64encode(<<EOT
${file("scripts/cold_vault.sh")}
EOT
)

  tags {
    key   = "Name"
    value = "${var.project_name}_cold_vault"
  }

}

resource "outscale_public_ip" "cold_vault_public_ip" {
}

resource "outscale_public_ip_link" "cold_vault_public_ip_link" {
  vm_id     = outscale_vm.vm_cold_vault.vm_id
  public_ip = outscale_public_ip.cold_vault_public_ip.public_ip
}

resource "outscale_nic" "cold_vault_nic" {
    subnet_id = outscale_subnet.dmz_subnet.subnet_id
    security_group_ids = [outscale_security_group.sg_cold_vault.security_group_id]
    private_ips {
      is_primary = true
      private_ip = var.cold_vault_ip
      }
}

resource "outscale_volume" "cold_vault_data" {
  subregion_name = "${var.osc_region}a"
  size           = var.cold_vault_volume_size
  volume_type    = "io1"
  iops           = var.cold_vault_volume_iops

  tags {
    key   = "Name"
    value = "${var.project_name}_cold_vault_data"
  }
}

resource "outscale_volume_link" "cold_vault_volume_link" {
  device_name = "/dev/xvdb"
  volume_id   = outscale_volume.cold_vault_data.volume_id
  vm_id       = outscale_vm.vm_cold_vault.vm_id
}


#########################
#      VM -CA (ISSUER)  #
#########################

resource "outscale_vm" "vm_ca_1" {
  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo    = var.server_key
  primary_nic  {
      nic_id = outscale_nic.ca_1_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-ca-1
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_ca_1"
  }

}

resource "outscale_nic" "ca_1_nic" {
    subnet_id = outscale_subnet.tools_subnet.subnet_id
    security_group_ids = [outscale_security_group.sg_tools.security_group_id]
    private_ips {
      is_primary = true
      private_ip = var.ca_1_ip
      }
}

resource "outscale_volume" "ca_1_data" {
  subregion_name = "${var.osc_region}a"
  size           = var.ca_1_volume_size
  volume_type    = "io1"
  iops           = var.ca_1_volume_iops

  tags {
    key   = "Name"
    value = "${var.project_name}_ca_1_data"
  }
}

resource "outscale_volume_link" "ca_1_volume_link" {
  device_name = "/dev/xvdb"
  volume_id   = outscale_volume.ca_1_data.volume_id
  vm_id       = outscale_vm.vm_ca_1.vm_id
}
