terraform {
  required_providers {
    outscale = {
      source = "outscale/outscale"
      version = "1.3.0"
    }
  }
}

provider "outscale" {
  access_key_id = var.osc_access_key
  secret_key_id = var.osc_secret_key
  region        = var.osc_region
  endpoints {
    api  = "api.eu-west-2.outscale.com"
  }
}
