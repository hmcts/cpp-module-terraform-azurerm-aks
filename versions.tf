
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.93.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.21.0"
    }
  }

  required_version = ">= 0.12"
}
