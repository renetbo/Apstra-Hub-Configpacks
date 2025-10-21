#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

terraform {
  required_providers {
    apstra = {
      source = "Juniper/apstra"
      version = "0.92.2"
    }
  }
}

provider "apstra" {
  # URL and credentials can be supplied using the "url" parameter in this file.
  # 4.2.1
  # url = "https://admin:Juniper123!@10.85.44.65:11343" 
  # 5.1.0  
  # url = "https://admin:Poclab123!@172.30.193.12"
  # 6.0.0
    url = "https://admin:Poclab123!@172.30.193.23"
  #
  # ...or using the environment variable APSTRA_URL.
  #
  # If Username or Password are not embedded in the URL, the provider will look
  # for them in the APSTRA_USER and APSTRA_PASS environment variables.
  #
  tls_validation_disabled = true  # CloudLabs doesn't present a valid TLS cert
  blueprint_mutex_enabled = false # Don't attempt worry about competing clients
}
