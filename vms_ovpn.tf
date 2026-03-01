resource "outscale_vm" "vm_ovpn" {
  image_id           = var.rocky_10_ami
  vm_type            = var.casual_vm_type
  keypair_name_wo       = var.dmz_vpn_key
  primary_nic  {
      nic_id = outscale_nic.ovpn_nic.nic_id
      device_number = "0"
      }

  user_data                = base64encode(<<EOT
${file("scripts/ovpn.sh")}
EOT
)

  tags {
    key   = "Name"
    value = "${var.project_name}_ovpn"
  }

}

resource "outscale_public_ip" "ovpn_public_ip" {
}

resource "outscale_public_ip_link" "ovpn_public_ip_link" {
  vm_id     = outscale_vm.vm_ovpn.vm_id
  public_ip = outscale_public_ip.ovpn_public_ip.public_ip
}

resource "outscale_nic" "ovpn_nic" {
    subnet_id = outscale_subnet.dmz_subnet.subnet_id
    security_group_ids = [outscale_security_group.sg_ovpn.security_group_id]
    private_ips {
      is_primary = true
      private_ip = var.ovpn_ip
      }
}

