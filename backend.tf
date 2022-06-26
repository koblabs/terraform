################################
# Consul backend
################################

terraform {

  backend "local" {}
  
  # backend "consul" {}

  # cloud {
  #   organization = "9naquame"

  #   workspaces {
  #     name = "koblabs"
  #   }
  # }
}
