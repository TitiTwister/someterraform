locals {
  k8s_workers = [
    for i, ip in var.k8s_worker_ips : {
      name = "k8s-worker-${i + 1}"
      ip   = ip
    }
  ]
}

resource "outscale_vm" "k8s_workers" {
  count = length(local.k8s_workers)

  image_id           = var.rocky_10_ami
  vm_type            = var.medium_vm_type
  keypair_name_wo    = var.server_key

  primary_nic {
    nic_id        = outscale_nic.k8s_workers_nics[count.index].nic_id
    device_number = "0"
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-${local.k8s_workers[count.index].name}
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_${local.k8s_workers[count.index].name}"
  }
}

resource "outscale_nic" "k8s_workers_nics" {
  count = length(local.k8s_workers)

  subnet_id          = outscale_subnet.k8s_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_k8s.security_group_id]

  private_ips {
    is_primary = true
    private_ip = local.k8s_workers[count.index].ip
  }
}

resource "outscale_volume" "k8s_worker_data" {
  count = length(local.k8s_workers)

  subregion_name = "${var.osc_region}a"
  size           = var.k8s_worker_volume_size
  volume_type    = var.k8s_worker_volume_type

  tags {
    key   = "Name"
    value = "${var.project_name}_${local.k8s_workers[count.index].name}_data"
  }
}

resource "outscale_volume_link" "k8s_worker_data_link" {
  count = length(local.k8s_workers)

  device_name = "/dev/xvdb"
  volume_id   = outscale_volume.k8s_worker_data[count.index].volume_id
  vm_id       = outscale_vm.k8s_workers[count.index].vm_id
}
