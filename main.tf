variable "name" {
  type    = string
  default = "analysis"
}

variable "location" {
  type    = string
  default = "westus2"
}

resource "random_integer" "lab" {
  min = 150000
  max = 650000
}

locals {
  name = "${var.name}${random_integer.lab.id}"
}

resource "azurerm_resource_group" "lab" {
  name     = local.name
  location = var.location

  tags = {
    Name      = local.name
    Terraform = true
  }
}

resource "azurerm_storage_account" "lab" {
  name                     = local.name
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Name      = local.name
    Terraform = true
  }
}

resource "azurerm_storage_container" "lab" {
  name                  = local.name
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

resource "azurerm_batch_account" "lab" {
  name                 = local.name
  resource_group_name  = azurerm_resource_group.lab.name
  location             = azurerm_resource_group.lab.location
  storage_account_id   = azurerm_storage_account.lab.id
  pool_allocation_mode = "UserSubscription"

  tags = {
    Name      = local.name
    Terraform = true
  }
}
