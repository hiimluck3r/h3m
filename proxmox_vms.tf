resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type = var.image_type
  datastore_id = var.image_storage
  node_name = var.node_name
  url = var.talos_image_url
}

resource "proxmox_virtual_environment_vm" "talos_masters" {
  depends_on = [ proxmox_virtual_environment_download_file.talos_image ]
  node_name = "pve"
  count = var.master_config.count
  name = format("talos-master-%s", count.index)
  stop_on_destroy = true
  on_boot = var.cluster_autostart

  cpu {
      cores = var.master_config.cpus
      sockets = var.master_config.sockets
      type = "x86-64-v2-AES"
  }

  memory {
      dedicated = var.master_config.memory
  }

  agent {
      enabled = true
  }

  initialization {
      datastore_id = var.disk_config.datastore_id
      ip_config {
          ipv4 {
              address = "dhcp"
          }
      }
  }

  cdrom {
    enabled = true
    file_id = proxmox_virtual_environment_download_file.talos_image.id
    interface = "ide0"

  }

  disk {
      datastore_id = var.disk_config.datastore_id
      file_format = "raw"
      interface = var.disk_config.interface
      iothread = var.disk_config.iothread
      discard = var.disk_config.discard
      size = var.master_config.disk_size
  }

  network_device {
      bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_vm" "talos_workers" {
  depends_on = [ proxmox_virtual_environment_download_file.talos_image ]
  node_name = "pve"
  count = var.worker_config.count
  name = format("talos-worker-%s", count.index)
  stop_on_destroy = true
  on_boot = var.cluster_autostart

  cpu {
      cores = var.worker_config.cpus
      sockets = var.worker_config.sockets
      type = "x86-64-v2-AES"
  }

  memory {
      dedicated = var.worker_config.memory
  }

  agent {
      enabled = true
  }

  initialization {
      datastore_id = var.disk_config.datastore_id
      ip_config {
          ipv4 {
              address = "dhcp"
          }
      }
  }

  cdrom {
    enabled = true
    file_id = proxmox_virtual_environment_download_file.talos_image.id
    interface = "ide0"

  }

  disk {
      datastore_id = var.disk_config.datastore_id
      file_format = "raw"
      interface = var.disk_config.interface
      iothread = var.disk_config.iothread
      discard = var.disk_config.discard
      size = var.worker_config.disk_size
  }

  network_device {
      bridge = "vmbr0"
  }
}

locals {
  master_ips = tolist(setsubtract(flatten(proxmox_virtual_environment_vm.talos_masters[*].ipv4_addresses), ["127.0.0.1"]))
  worker_ips = tolist(setsubtract(flatten(proxmox_virtual_environment_vm.talos_workers[*].ipv4_addresses), ["127.0.0.1"]))
}