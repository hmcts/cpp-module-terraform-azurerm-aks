
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.21.0"
    }
  }

  required_version = ">= 0.12"
}
