terraform {
  required_version = ">= 0.13.0"

  required_providers {
    gitops = {
      source = "cloud-native-toolkit/gitops"
      version = ">= 0.1.7"
    }
  }
}
