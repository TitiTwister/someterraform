resource "outscale_vm" "metallb_parking" {
  image_id        = var.rocky_10_ami
  vm_type         = var.small_vm_type
  keypair_name_wo = var.server_key
  state           = "stopped"

  primary_nic {
    nic_id        = outscale_nic.metallb_parking_nic.nic_id
    device_number = "0"
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-metallb-parking-1
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_metallb_parking_1"
  }
}

resource "outscale_nic" "metallb_parking_nic" {
  subnet_id          = outscale_subnet.k8s_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_k8s.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.metallb_parking_ip
  }

  dynamic "private_ips" {
    for_each = var.metallb_parking_secondary_ips
    content {
      is_primary = false
      private_ip = private_ips.value
    }
  }
}
