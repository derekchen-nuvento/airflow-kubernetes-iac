terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws        = ">= 3.22.0, < 4.0.0"
    local      = ">= 1.4"
    random     = ">= 2.1"
    kubernetes = ">= 1.13"
    
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.5.1"
    }
  
  }
}