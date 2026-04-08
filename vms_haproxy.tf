resource "outscale_vm" "vm_haproxy" {
  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo       = var.dmz_other_key
  primary_nic  {
      nic_id = outscale_nic.haproxy_nic.nic_id
      device_number = "0"
      }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    hostnamectl set-hostname ${var.project_name}_haproxy
    dnf install epel-release -y
  EOT
  )

  tags {
    key   = "Name"
    value = "${var.project_name}_haproxy"
  }

}

resource "outscale_public_ip" "haproxy_public_ip" {
}

resource "outscale_public_ip_link" "haproxy_public_ip_link" {
  vm_id     = outscale_vm.vm_haproxy.vm_id
  public_ip = outscale_public_ip.haproxy_public_ip.public_ip
}

resource "outscale_nic" "haproxy_nic" {
    subnet_id = outscale_subnet.dmz_subnet.subnet_id
    security_group_ids = [outscale_security_group.sg_haproxy.security_group_id]
    private_ips {
      is_primary = true
      private_ip = var.haproxy_ip
      }
}
