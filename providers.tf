terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.52"
    }
  }
}

provider "azurerm" {
  features {}
}