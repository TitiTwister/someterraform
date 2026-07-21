
resource "outscale_vm" "vm_grafana_1" {

  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo    = var.server_key

  primary_nic  {
      nic_id = outscale_nic.grafana_1_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-grafana-1
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_grafana_1"
  }
}

resource "outscale_nic" "grafana_1_nic" {

  subnet_id          = outscale_subnet.tools_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_tools.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.grafana_ip
  }
}

