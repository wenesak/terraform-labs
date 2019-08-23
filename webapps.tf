locals {
    webappsperloc   = 2
}

resource "azurerm_resource_group" "Lab-webapps-RG" {
  name     = "Lab-webapps-RG"
  location = "${var.loc}"
  tags     = "${var.tags}"
}

resource "random_string" "webapprnd" {
  length  = 8
  lower   = true
  number  = true
  upper   = false
  special = false
}

resource "azurerm_app_service_plan" "free" {
    count               = "${length(var.webapplocs)}"
    name                = "plan-free-${var.webapplocs[count.index]}"
    location            = "${var.webapplocs[count.index]}"
    #name                = "plan-free-${var.loc}"
    #location            = "${var.loc}"
    resource_group_name = "${azurerm_resource_group.Lab-webapps-RG.name}"
    tags                = "${azurerm_resource_group.Lab-webapps-RG.tags}"

    kind                = "Linux"
    reserved            = true
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "citadel" {
    count               = "${length(var.webapplocs) * local.webappsperloc}"
    #name                = "webapp-${random_string.webapprnd.result}-${var.webapplocs[count.index]}"
    name                = "${format("webapp-%s-%02d-%s", random_string.webapprnd.result, count.index + 1, element(var.webapplocs, count.index))}"
    #location            = "${element(var.webapplocs, 1)}"
    #location            = "${var.webapplocs[1]}"
    location            = "${element(var.webapplocs, count.index)}"
    resource_group_name = "${azurerm_resource_group.Lab-webapps-RG.name}"
    tags                = "${azurerm_resource_group.Lab-webapps-RG.tags}"
    app_service_plan_id = "${element(azurerm_app_service_plan.free.*.id, count.index)}"
    #app_service_plan_id = "${azurerm_app_service_plan.free.id}"
}
 
output "webapp_ids" {
  value = "${azurerm_app_service.citadel.*.id}"
}

output "webapp_default_site_hostname" {
 value = "${azurerm_app_service.citadel.*.default_site_hostname}"
}