variable "proxmox_user" {
    description = "Proxmox user that will perform VM management"
    type = string
    default = "root@pam"
}

variable "talos_flavor" {
    description = "Talos Factory installer. Do not set it if you're using classic talos"
    type = string
    default = "ghcr.io/siderolabs/installer:v1.7.2"
}

variable "github_repository" {
    description = "Information about new GitHub repository for FluxCD"
    type = object({
      name = string
      description = string
      visibility = string
    })
    default = {
      name = "h3m"
      description = "Homelab built with Talos on Proxmox and managed with Flux"
      visibility = "private"
    }
}

variable "github_owner" {
    description = "Owner of the repository"
    type = string
    default = ""
}

variable "github_pat" {
    description = "GitHub Personal Access Token that is used for FluxCD provisioning"
    type = string
    sensitive = true
}

variable "cidr" {
    description = "CIDR mask that allows specific IPs to be picked"
    type = string
}

variable "cluster_name" {
    description = "Name of your cluster"
    type = string
    default = "h3m-talos-cluster"
}

variable "cluster_endpoint" {
    description = "Kubernetes endpoint for VIP"
    type = string
}

variable "gateway" {
    type = string
    default = "192.168.0.1"
}

variable "image_storage" {
    description = "Place where all images are stored"
    type = string
    default = "local"
}

variable "image_type" {
    description = "Image type that is used"
    type = string
    default = "iso"
}

variable "talos_image_url" {
    description = "Talos Linux image that is used for the cluster, might be downloaded vanilla or created with factory.talos.dev"
    type = string
    default = "https://factory.talos.dev/image/dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586/v1.7.2/nocloud-amd64.iso"
}

variable "node_name" {
    description = "Name of the node on which we'll create VMs"
    type = string
    default = "pve"
}

variable "cluster_autostart" {
    description = "Boot cluster on start"
    type = bool
}

variable "proxmox_password" {
    description = "Proxmox user's password"
    type = string
    sensitive = true
}

variable disk_config {
    description = "VMs disk configuration"
    type = object({
      datastore_id = string
      interface = string
      iothread = bool
      discard = string
    })
}

variable "proxmox_endpoint" {
    description = "Proxmox endpoint"
    type = string
}

variable "default_bridge" {
    description = "Default bridge interface used to create VMs"
    type = string
}

variable "master_config" {
    description = "Config for master VMs"
    type = object({
      count = number
      memory = number
      cpus = number
      sockets = number
      disk_size = number
    })

    validation {
        condition = var.master_config.count != 0  || var.master_config.cpus != 0 || var.master_config.sockets != 0 || var.master_config.disk_size != 0
        error_message = "Wrong information, please check the amount of master servers, disk_size, cpus and sockets that are attached to a master VM"
    }
}

variable "worker_config" {
    description = "Config for master VMs"
    type = object({
      count = number
      memory = number
      cpus = number
      sockets = number
      disk_size = number
    })

    validation {
        condition = var.worker_config.cpus != 0 || var.worker_config.sockets != 0 || var.worker_config.disk_size != 0
        error_message = "Wrong information, please check the amount of disk_size, cpus and sockets that are attached to a worker VM"
    }
}