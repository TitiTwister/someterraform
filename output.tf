output "ovpn_ip_addr" {
  value       = outscale_public_ip.ovpn_public_ip.public_ip
  description = "The public IP address of the ovpn VM."
}

output "wireguard_ip_addr" {
  value       = outscale_public_ip.wireguard_public_ip.public_ip
  description = "The public IP address of the WireGuard VM."
}

output "cold_vault_ip_addr" {
  value       = outscale_public_ip.cold_vault_public_ip.public_ip
  description = "The public IP address of the ovpn VM."
}

output "haproxy_ip_addr" {
  value       = outscale_public_ip.haproxy_public_ip.public_ip
  description = "The public IP address of the haproxy VM."
}


