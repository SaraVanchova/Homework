terraform {
    required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.36.0"
    }
  }
  backend "azurerm" {
    
  }
}
data "azurerm_subscription" "current" {

}