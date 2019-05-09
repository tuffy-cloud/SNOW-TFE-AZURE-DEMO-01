# Configure the Azure Provider

# Configure the Azure Provider
provider "azurerm" {
}

# Create a resource group
resource "azurerm_resource_group" "test" {
  name     = "tuffyproduction"
  location = "West US"
}
