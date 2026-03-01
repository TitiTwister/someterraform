output "ovpn_ip_addr" {
  value       = outscale_public_ip.ovpn_public_ip.public_ip
  description = "The public IP address of the ovpn VM."
}