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
            VNetKey = "opellavnet"
            AzureRegion = "usc"
            AddressPrefix = ["10.40.0.0/27"]
            ServiceEndpoints = {}
            Delegation = {}
    },
    "app-subnet" = {
            VNetKey = "opellavnet"
            AzureRegion = "usc"
            AddressPrefix = ["10.40.0.64/27"]
            ServiceEndpoints = ["Microsoft.Storage", "Microsoft.Web" ]
            Delegation = {}
    }
  }

    }
    Env = "prd"
    location = "CentralUS"
    tags = {}