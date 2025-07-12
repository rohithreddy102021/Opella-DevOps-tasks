resourcegroups = {
        rg1 = {
            Name = "opella"
            AzureRegion = "usc"
        }

    }
VNet = {
  VNet = {
    "opellavnet" = {
            Name = "opella"
            AzureRegion = "usc"
            RGKey = "rg1"
            AddressSpace = ["10.40.0.0/24"]
    }
  }
  Subnets = {
    "pep-subnet" = {
            Name = "opella-pep-subnet"
            VNetKey = "opellavnet"
            AzureRegion = "usc"
            AddressPrefix = "10.40.0.0/27"
            ServiceEndpoints = []
            Delegation = null
            NSGSubnetKey = ""
            private_endpoint_network_policies = "Enabled" 
    },
    "app-subnet" = {
            Name = "opella-app-subnet"
            VNetKey = "opellavnet"
            AzureRegion = "usc"
            AddressPrefix = "10.40.0.64/27"
            ServiceEndpoints = ["Microsoft.Storage", "Microsoft.Web" ]
            Delegation = null
            private_endpoint_network_policies = "Enabled"
            NSGSubnetKey = ""
    }
  }
}
 NSG = {
  NSG = {
    "nsg1" = {
            AzureRegion = "usc"
            RGKey = "rg1"
    }
  }
  NSGRules = {
    "AllowHTTPSInbound" = {
       priority = 100
       Direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "443"
       source_address_prefix = "*"
       destination_address_prefix = "*"
       RGKey = "rg1"
       NSGSubnetKey = "nsg1"
    }
  }
 }
  Subnet = {
    "opella-pep-subnet-dev-usc" = {
      subnetkey = "pep-subnet"
      nsgkey = "nsg1"
    },
    "opella-app-subnet-dev-usc" = {
      subnetkey = "app-subnet"
      nsgkey = "nsg1"
    }
    
  }

    Env = "prd"
    location = "CentralUS"
    tags = {}