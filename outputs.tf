resource "local_file" "talosconfig" {
    depends_on = [ data.talos_cluster_kubeconfig.this ]
    content = data.talos_client_configuration.this.talos_config
    filename = "configs/talosconfig"
}

resource "local_file" "kubeconfig" {
    depends_on = [ data.talos_cluster_kubeconfig.this ]
    content = data.talos_cluster_kubeconfig.this.kubeconfig_raw
    filename = "configs/kubeconfig"
}

resource "local_file" "worker_config" {
    depends_on = [ data.talos_machine_configuration.these_workers ]
    content = data.talos_machine_configuration.these_workers.machine_configuration
    filename = "configs/worker.yaml"
}

resource "local_file" "master_config" {
    depends_on = [ data.talos_machine_configuration.these_masters ]
    content = data.talos_machine_configuration.these_masters.machine_configuration
    filename = "configs/controlplane.yaml"
}

resource "local_file" "cilium_config" {
    depends_on = [ data.helm_template.cilium_template ]
    content = templatefile("${path.root}/patches/cilium-cni-template.yaml", {cilium_yaml = data.helm_template.cilium_template.manifest})
    filename = "patches/cilium-cni-patch.yaml"
}