# Define Terraform Provider To Use

provider "azurerm" {
}

# Create Resource Group in Azure

resource "azurerm_resource_group" "tuffyrg01" {
    name     = "demo01"
    location = "eastus"

    tags {
        environment = "Terraform Demo"
    }
}

# Create Azure Virtual Network for demo01

resource "azurerm_virtual_network" "tuffyvn01" {
    name                = "demo-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.tuffyrg01.name}"

    tags {
        environment = "Terraform Demo"
    }
}

# Create Subnet within Azure Virtual Network for demo

resource "azurerm_subnet" "tuffysubnet01" {
    name                 = "Public-Subnet"
    resource_group_name  = "${azurerm_resource_group.tuffyrg01.name}"
    virtual_network_name = "${azurerm_virtual_network.tuffyvn01.name}"
    address_prefix       = "10.0.2.0/24"
}

# Create Public IP Address For Azure VM Instance

resource "azurerm_public_ip" "tuffytfpubip01" {
    name                         = "demopublicip01"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.tuffyrg01.name}"
    allocation_method            = "Dynamic"

    tags {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group & Rule for Demo Instance

resource "azurerm_network_security_group" "tuffynsg01" {
    name                = "TuffyNetworkSecurityGroup01"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.tuffyrg01.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Terraform Demo"
    }
}

# Create Azure Network Interface Card for Demo Instance

# Create Network Interface Card for Azure VM

resource "azurerm_network_interface" "tuffynic01" {
    name                = "DemoNIC01"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.tuffyrg01.name}"
    network_security_group_id = "${azurerm_network_security_group.tuffynsg01.id}"

    ip_configuration {
        name                          = "Demo01NicConfiguration"
        subnet_id                     = "${azurerm_subnet.tuffysubnet01.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.tuffytfpubip01.id}"
    }

    tags {
        environment = "Terraform Demo"
    }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "tuffystorageaccount" {
    name                        = "diagdemo01"
    resource_group_name         = "${azurerm_resource_group.tuffyrg01.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "Terraform Demo"
    }
}
