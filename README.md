# Simple Outscale VPC Infrastructure

Terraform project to deploy a VPC infrastructure on Outscale cloud.

## Architecture

                    └──-------------------------------------------------------+
                    |                       Internet                          |
                    └──-----------------------└──-----------------------------+
                                              |
                                     └──------v--------+
                                     |  Internet GW    |
                                     |  (main_vpc_igw) |
                                     └──------^--------+
                                              |
        └──-----------------------------------└──----------------------------------+
        |                          main_vpc (10.0.0.0/16)                            |
        |                                                                          |
        |  └──------------------------+  └──------------------------+  └──-------------+
        |  |      DMZ Subnet          |  |    Tools Subnet          |  | K8s Subnet    |
        |  |   10.0.0.0/24            |  |   10.0.100.0/24          |  | 10.0.8.0/24   |
        |  |                          |  |                          |  |               |
        |  |  └──------------------+  |  |  └──----------------+    |  |  └──--------+ |
        |  |  | OpenVPN Server     |  |  |  | DNS (NS)         |    |  |  | K8s      | |
        |  |  | 10.0.0.254         |  |  |  | 10.0.100.11/12   |    |  |  |Controller| |
        |  |  └──------------------+  |  |  └──----------------+    |  |  | 10.0.8.10| |
        |  |                          |  |                          |  |  └──--------+ |
        |  |  └──------------------+  |  |  └──----------------+    |  |  └──--------+ |
        |  |  | HAProxy            |  |  |  | Prometheus       |    |  |  | K8s      | |
        |  |  | 10.0.0.200         |  |  |  | 10.0.100.20/21   |    |  |  | Masters  | |
        |  |  └──------------------+  |  |  └──----------------+    |  |  |          | |
        |  |                          |  |                          |  |  └──--------+ |
        |  |  └──------------------+  |  |  └──----------------+    |  |  └──--------+ |
        |  |  | Cold Vault         |  |  |  | Grafana          |    |  |  | K8s      | |
        |  |  | 10.0.0.253         |  |  |  | 10.0.100.22      |    |  |  | Workers  | |
        |  |  └──------------------+  |  |  └──----------------+    |  |  |          | |
        |  |                          |  |                          |  |  └──--------+ |
        |  |                          |  |  └──----------------+    |  |  └──--------+ |
        |  |                          |  |  | CA Issuer        |    |  |  |PostgreSQL| |
        |  |                          |  |  | 10.0.100.5       |    |  |  | 10.0.8.4 | |
        |  |                          |  |  └──----------------+    |  |  └──--------+ |
        |  └──------------------------+  └──------------------------+  └──-------------+
        |              |                              |                    |
        |              | Public RT                    |                    |
        |              | (0.0.0.0/0 -> IGW)           |                    |
        |              |                              |                    |
        |              |              └──-------------└──------------------+
        |              |              |
        |              |         └──--v-----+
        |              |         | NAT GW   |
        |              |         | (main_   |
        |              |         | vpc_nat) |
        |              |         └──--------+
        └──------------└──----------------------------------└──--------------------+
                       |
                └──----v------+
                |  Public IP  |
                |   (EIP)     |
                └──-----------+

## Project Structure

```
.
├── net.tf                   # VPC and subnets
├── igw.tf                   # Internet gateway
├── nat.tf                   # NAT gateway and EIP
├── rt.tf                    # Route tables
├── sg_cold_vault.tf         # Security group for Cold Vault
├── sg_haproxy.tf            # Security group for HAProxy
├── sg_k8s.tf                # Security group for Kubernetes nodes
├── sg_ovpn.tf               # Security group for OpenVPN
├── sg_tools.tf              # Security group for tools
├── vms_grafana.tf           # Grafana VM
├── vms_haproxy.tf           # HAProxy VM
├── vms_k8s_controller.tf    # Kubernetes controller VM
├── vms_k8s_master.tf        # Kubernetes master nodes
├── vms_k8s_worker.tf        # Kubernetes worker nodes (+ data disks)
├── vms_ns.tf                # DNS (NS) VMs
├── vms_ovpn.tf              # OpenVPN VM
├── vms_pki.tf               # Cold Vault and CA issuer VMs (+ data disks)
├── vms_postgresql.tf        # PostgreSQL VMs (+ data disks)
├── vms_prometheus.tf        # Prometheus VMs (+ data disks)
├── variables.tf             # Variable definitions
├── outputs.tf               # Output definitions
├── providers.tf             # Provider configuration
├── terraform.tfvars         # Variable values
└── scripts/
    ├── cold_vault.sh        # Cold Vault setup script
    └── ovpn.sh              # OpenVPN setup script
```

## Configuration

### Required Variables

Create a `terraform.tfvars` file with at least the following:

```hcl
# Outscale credentials
osc_access_key = "YOUR_ACCESS_KEY"
osc_secret_key = "YOUR_SECRET_KEY"

# Project naming
project_name     = "main_vpc"
dns_project_name = "main-vpc"

# SSH key names (must already exist in Outscale)
dmz_vpn_key   = "YOUR_VPN_KEY_NAME"
dmz_other_key = "YOUR_OTHER_DMZ_KEY_NAME"
server_key    = "YOUR_SERVER_KEY_NAME"

# Allowed IPs for SSH access to VPN
allowed_cidr = [
  "YOUR_PUBLIC_IP/32"
]
```

Optional variables (subnets, IP addresses, VM types, volume sizes) can be overridden in `terraform.tfvars` as well. See `variables.tf` for the full list and defaults.

## Outputs

| Output | Description |
|--------|-------------|
| `ovpn_ip_addr` | Public IP address of the OpenVPN server |
| `cold_vault_ip_addr` | Public IP address of the Cold Vault server |
| `haproxy_ip_addr` | Public IP address of the HAProxy server |

## Network Summary

| Subnet | CIDR | Purpose | Access |
|--------|------|---------|--------|
| DMZ | 10.0.0.0/24 | Public-facing services | Internet via IGW |
| Tools | 10.0.100.0/24 | Internal tools/monitoring | Internet via NAT |
| K8s | 10.0.8.0/24 | Kubernetes cluster and databases | Internet via NAT |

## VM / Service Summary

| Role | Subnet | Private IP(s) | VM Type | Notes |
|------|--------|---------------|---------|-------|
| OpenVPN | DMZ | 10.0.0.254 | `casual_vm_type` | Public IP attached |
| HAProxy | DMZ | 10.0.0.200 | `casual_vm_type` | Public IP attached |
| Cold Vault | DMZ | 10.0.0.253 | `casual_vm_type` | 50 GB `io1` data disk, public IP attached |
| DNS (NS) | Tools | 10.0.100.11, 10.0.100.12 | `casual_vm_type` | Pair of name servers |
| Prometheus | Tools | 10.0.100.20, 10.0.100.21 | `casual_vm_type` | 50 GB `io1` data disk |
| Grafana | Tools | 10.0.100.22 | `casual_vm_type` | Monitoring dashboard |
| CA Issuer | Tools | 10.0.100.5 | `casual_vm_type` | 50 GB `io1` data disk |
| PostgreSQL | K8s | 10.0.8.4, 10.0.8.5, 10.0.8.6 | `medium_vm_type` | 200 GB `io1` data disk each |
| K8s Controller | K8s | 10.0.8.10 | `small_vm_type` | Smallest VM size |
| K8s Masters | K8s | 10.0.8.11, 10.0.8.12, 10.0.8.13 | `casual_vm_type` | Kubernetes control plane |
| K8s Workers | K8s | 10.0.8.101, 10.0.8.102, 10.0.8.103 | `medium_vm_type` | 200 GB `gp2` data disk each |

## License

Beerware License

Use this code however you want. If we meet someday and you think this stuff is worth it, you can buy me a beer in return.
