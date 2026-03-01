# Simple Outscale VPC Infrastructure

Terraform project to deploy a simple VPC infrastructure on Outscale cloud. 


## Architecture

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                    Internet                             │
                    └────────────────────────┬────────────────────────────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Internet GW    │
                                    │  (main_vpc_igw) │
                                    └────────┬────────┘
                                             │
        ┌────────────────────────────────────┼────────────────────────────────────┐
        │                         main_vpc (10.0.0.0/16)                              │
        │                                                                                 │
        │  ┌──────────────────────────┐  ┌──────────────────────────┐  ┌───────────┐
        │  │      DMZ Subnet          │  │    Tools Subnet          │  │ K8s Subnet│
        │  │   10.0.0.0/24            │  │   10.0.100.0/24          │  │10.0.8.0/24│
        │  │                          │  │                          │  │           │
        │  │  ┌────────────────────┐  │  │                          │  │           │
        │  │  │   OpenVPN Server   │  │  │  (Monitoring, CI/CD)     │  │  K8s      │
        │  │  │   10.0.0.254       │  │  │                          │  │  Masters  │
        │  │  └────────────────────┘  │  │                          │  │           │
        │  └──────────────────────────┘  └──────────────────────────┘  └───────────┘
        │              │                              │                    │
        │              │ Public RT                    │                    │
        │              │ (0.0.0.0/0 → IGW)            │                    │
        │              │                              │                    │
        │              │              ┌───────────────┴────────────────────┘
        │              │              │
        │              │         ┌────▼─────┐
        │              │         │ NAT GW   │
        │              │         │(main_vpc │
        │              │         │ _natgw)  │
        │              │         └──────────┘
        └──────────────┼─────────────────────────────────────────────────────────────┘
                       │
                ┌──────▼──────┐
                │  Public IP  │
                │   (EIP)     │
                └─────────────┘
```

## Project Structure

```
.
├── net.tf               # VPC and subnets
├── igw.tf               # Internet gateway
├── nat.tf               # NAT gateway and EIP
├── rt.tf                # Route tables
├── sg_ovpn.tf           # Security group for VPN
├── sg_tools.tf          # Security group for tools
├── sg_k8s.tf            # Security group for Kubernetes
├── vms_ovpn.tf          # OpenVPN VM
├── vms_k8s_master.tf    # Kubernetes master nodes
├── vms_k8s_worker.tf    # Kubernetes worker nodes
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions
├── providers.tf         # Provider configuration
├── terraform.tfvars     # Variable values
└── scripts/
    └── ovpn.sh          # OpenVPN setup script
```

## Configuration

### Required Variables

Create a `terraform.tfvars` file with the following:

```hcl
# Outscale credentials
osc_access_key = "YOUR_ACCESS_KEY"
osc_secret_key = "YOUR_SECRET_KEY"

# Project naming
project_name = "main_vpc"

# SSH key names (must already exist in Outscale)
dmz_vpn_key  = "YOUR_VPN_KEY_NAME"
server_key   = "YOUR_SERVER_KEY_NAME"

# Allowed IPs for SSH access to VPN
allowed_cidr = [
  "YOUR_PUBLIC_IP/32"
]
```

## Outputs

| Output | Description |
|--------|-------------|
| `ovpn_ip_addr` | Public IP address of the OpenVPN server |

## Network Summary

| Subnet | CIDR | Purpose | Access |
|--------|------|---------|--------|
| DMZ | 10.0.0.0/24 | Public-facing services | Internet via IGW |
| Tools | 10.0.100.0/24 | Internal tools/monitoring | Internet via NAT |
| K8s | 10.0.8.0/24 | Kubernetes cluster | Internet via NAT |

## License

Beerware License

Use this code however you want. If we meet someday and you think this stuff is worth it, you can buy me a beer in return.
