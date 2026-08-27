resource "outscale_vm" "k8s_controller" {
  image_id           = var.rocky_10_ami
  vm_type            = var.small_vm_type
  keypair_name_wo    = var.server_key

  primary_nic {
    nic_id        = outscale_nic.k8s_controller_nic.nic_id
    device_number = "0"
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-k8s-controller-1
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_k8s_controller_1"
  }
}

resource "outscale_nic" "k8s_controller_nic" {
  subnet_id          = outscale_subnet.k8s_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_k8s.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.k8s_controller_ip
  }
}
