module "rg" {
    source = "./modules/ResourceGroups"
    resourcegroups = var.resourcegroups
    Env = var.Env
    location = var.location
    tags = var.tags
}
module "vnet" {
    source = "./modules/VirtualNetworksandSubnet"
    VNet = var.VNet
    Env = var.Env
    resourcegroups = module.rg.resource_group_name
    tags = var.tags
    location = var.location
}
module "nsg" {
    source = "./modules/NSG"
    NSG = var.NSG
    VNet = var.VNet
    Subnet = module.vnet.Subnet
    Env = var.Env
    resourcegroups = module.rg.resource_group_name
    tags = var.tags
    location = var.location
    depends_on = [ module.vnet, module.rg ]
}
