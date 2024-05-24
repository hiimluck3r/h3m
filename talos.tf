resource "talos_machine_secrets" "this" {}

data "talos_client_configuration" "this" {
  depends_on = [ proxmox_virtual_environment_vm.talos_masters, proxmox_virtual_environment_vm.talos_workers ]
  cluster_name = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes = concat(local.master_ips, local.worker_ips)
  endpoints = [ local.master_ips[0] ]
}

data "talos_machine_configuration" "these_workers" {
  depends_on = [ data.talos_client_configuration.this ]
  cluster_name = var.cluster_name
  machine_type = "worker"
  cluster_endpoint = format("https://%s:6443", var.cluster_endpoint)
  machine_secrets = talos_machine_secrets.this.machine_secrets
  config_patches = [
    file("${path.root}/patches/kubelet-certificate.yaml"),
    file("${path.root}/patches/interface-names.yaml"),
    file("${path.root}/patches/ipvs-strict-arp.yaml"),
    yamlencode({
      machine = {
        install = {
          image = var.talos_flavor
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "these_workers" {
  depends_on = [ data.talos_machine_configuration.these_workers ]
  count = var.worker_config.count
  client_configuration = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.these_workers.machine_configuration
  node = local.worker_ips[count.index]
}

data "talos_machine_configuration" "these_masters" {
  depends_on = [ data.talos_client_configuration.this ]
  cluster_name = var.cluster_name
  machine_type = "controlplane"
  cluster_endpoint = format("https://%s:6443", var.cluster_endpoint)
  machine_secrets = talos_machine_secrets.this.machine_secrets
  config_patches = [
    file("${path.root}/patches/vip.yaml"),
    file("${path.root}/patches/kubelet-certificate.yaml"),
    file("${path.root}/patches/interface-names.yaml"),
    file("${path.root}/patches/ipvs-strict-arp.yaml"),
    yamlencode({
      machine = {
        install = {
          image = var.talos_flavor
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "these_masters" {
  depends_on = [ data.talos_machine_configuration.these_masters ]
  count = var.master_config.count
  client_configuration = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.these_masters.machine_configuration
  node = local.master_ips[count.index]
}

resource "time_sleep" "wait_until_reboot" {
  depends_on = [
    talos_machine_configuration_apply.these_masters,
    talos_machine_configuration_apply.these_workers
  ]
  create_duration = "4m"
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [
    time_sleep.wait_until_reboot
  ]
  node = local.master_ips[0]
  client_configuration = talos_machine_secrets.this.client_configuration
}

data "talos_cluster_kubeconfig" "this" {
  depends_on = [ talos_machine_bootstrap.this ]
  client_configuration = talos_machine_secrets.this.client_configuration
  node = local.master_ips[0]
}

resource "time_sleep" "wait_until_bootstrap" {
  depends_on = [
    local_file.kubeconfig,
    local_file.talosconfig
  ]
  create_duration = "5m"
}