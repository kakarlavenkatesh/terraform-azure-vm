resource "azurerm_resource_group" "rg" {
  name     = "rg-jenkins-tf"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-jenkins"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    create_before_destroy = true
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "jenkins-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCLG8aHTd6sP0XTcBs9uJFZNV/1Kb1EeedYtxZSenuFIsa8fzow8srOzv3xO3CTAoGcDHhbhWEMJTlvsmnzYioNoywuUlXTn+m1VWlvJznWKK76bXN9MedfydoIED9n2tjiaAWTKOSYDYU3CjiAHJhN4U4yJONNaFBMxaliEWq/uqKQHGHhdWIHepJNH/tux0c+87jOV957QkmBuGhGWJ/OqH6AdujVKJcMIfFlmwypNq5Rte8v32SEjpf3oQMnIdOOoUJ8kPBESkAijdmOCWSV+uMBePAjzQx+P5ZIU8XgXFGge2M3AptsTtxoSs/UdS71XakrbNC9k98if6YVAkGeg08dokuOMPZCyrsZH8eUkA6D9JRcKZbZNYf5+pfQyTygzksXNdgzeN5JAzL5UfCkGCGP+VAMwzutsKIVqfx3Kje57jQKv9zSIVMxE/AShQttlFhwayk9GtecctJ6Ceg7ftYNqkZDpd84rxPhpZx9gUveZ1EWGRmHnsaSNg/jVQHo7d80EpDsu1HzR+Fnlwuhw4HsVb6JAxF0y8XLv1PtO9hE+HPqd9K+cU5Fdw8titBI2llU5dZ9cctpEzR5xr8twkKMb5isxD49T47Zo3e2wCubQwCnb43cnBPLEW3Wi287NL4EHuTVHDwZ/OIztCAOYHyH3sOFtG1H2PIGOl8M7Q== azureuser@linnux-jenkins"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
