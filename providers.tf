terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.57.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.5.0"
    }
    github = {
      source = "integrations/github"
      version = "6.2.1"
    }
    flux = {
      source = "fluxcd/flux"
      version = "1.3.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_user
  password = var.proxmox_password
  insecure = true
  tmp_dir  = "/var/tmp"

  ssh {
    agent = true
  }
}

provider "flux" {
  kubernetes = {
    config_path = "configs/kubeconfig"
  }
  git = {
    url = "https://github.com/${var.github_owner}/${var.github_repository.name}.git"
    http = {
      username = "h3m" # This can be any string when using a personal access token
      password = var.github_pat
    }
  }
}

provider "github" {
  owner = var.github_owner
  token = var.github_pat
}

provider "helm" {
  kubernetes {
    config_path = "${path.root}/configs/kubeconfig"
  }
}

provider "talos" {}