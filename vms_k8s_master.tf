locals {
  k8s_masters = [
    for i, ip in var.k8s_master_ips : {
      name = "k8s-master-${i + 1}"
      ip   = ip
    }
  ]
}

resource "outscale_vm" "k8s_masters" {
  count = length(local.k8s_masters)

  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo    = var.server_key

  primary_nic {
    nic_id        = outscale_nic.k8s_master_nics[count.index].nic_id
    device_number = "0"
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${local.k8s_masters[count.index].name}
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_${local.k8s_masters[count.index].name}"
  }
}

resource "outscale_nic" "k8s_master_nics" {
  count = length(local.k8s_masters)

  subnet_id          = outscale_subnet.k8s_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_k8s.security_group_id]

  private_ips {
    is_primary = true
    private_ip = local.k8s_masters[count.index].ip
  }
}
