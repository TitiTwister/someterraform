
resource "outscale_vm" "vm_ns_1" {

  image_id           = var.rocky_10_ami
  vm_type            = var.small_vm_type
  keypair_name_wo    = var.server_key

  primary_nic  {
      nic_id = outscale_nic.ns_1_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.dns_project_name}-ns-1
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_ns_1"
  }
}

resource "outscale_nic" "ns_1_nic" {

  subnet_id          = outscale_subnet.tools_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_tools.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.ns_ips[0]
  }
}


resource "outscale_vm" "vm_ns_2" {

  image_id           = var.rocky_10_ami
  vm_type            = var.small_vm_type
  keypair_name_wo    = var.server_key

  primary_nic  {
      nic_id = outscale_nic.ns_2_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.project_name}-ns-2
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_ns_2"
  }
}

resource "outscale_nic" "ns_2_nic" {

  subnet_id          = outscale_subnet.tools_subnet.subnet_id
  security_group_ids = [outscale_security_group.sg_tools.security_group_id]

  private_ips {
    is_primary = true
    private_ip = var.ns_ips[1]
  }
}
