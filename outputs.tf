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