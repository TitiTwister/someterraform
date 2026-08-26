locals {
  postgresql_vms = [
    for i, ip in var.postgresql_ips : {
      name = "postgresql-${i + 1}"
      ip   = ip
    }
  ]
}

resource "outscale_vm" "postgresql_vms" {
  count = length(local.postgresql_vms)

  image_id           = var.rocky_10_ami
  vm_type            = var.medium_vm_type
  keypair_name_wo    = var.server_key

  primary_nic {
    nic_id        = outscale_nic.postgresql_nics[count.index].nic_id
    device_number = "0"
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-${local.postgresql_vms[count.index].name}
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_${local.postgresql_vms[count.index].name}"
  }
}

resource "outscale_nic" "postgresql_nics" {
  count = length(local.postgresql_vms)

  subnet_id          = outscale_subnet.k8s_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_k8s.security_group_id]

  private_ips {
    is_primary = true
    private_ip = local.postgresql_vms[count.index].ip
  }
}

resource "outscale_volume" "postgresql_data" {
  count = length(local.postgresql_vms)

  subregion_name = "${var.osc_region}a"
  size           = var.postgresql_volume_size
  volume_type    = "io1"
  iops           = var.postgresql_volume_iops

  tags {
    key   = "Name"
    value = "${var.project_name}_${local.postgresql_vms[count.index].name}_data"
  }
}

resource "outscale_volume_link" "postgresql_data_link" {
  count = length(local.postgresql_vms)

  device_name = "/dev/xvdb"
  volume_id   = outscale_volume.postgresql_data[count.index].volume_id
  vm_id       = outscale_vm.postgresql_vms[count.index].vm_id
}
