                         
<br/>
<div align="center">
<a href="https://github.com/hiimluck3r/h3m">
<img src="docs/images/logo.png" alt="Logo" width="160" height="160">
</a>
<h3 align="center">h3m</h3>
<p align="center">
It's like h2m, but better
<br/>
<br/>
<a href="https://github.com/hiimluck3r/h3m/tree/main/docs"><strong>Explore the docs »</strong></a>
</p>
</div>

 ## About The Project

This project is basically my homelab, which I'm going to use for a while (I think so... I hope so). 

The first iteration was called h2m ("hiim", "host to machine", etc), since this is a newer version, I just added 1. The name doesn't make any sense.

 ### Built With

In order to be as efficient (and fancy) as possible, I decided to switch from k3s to Talos Linux, and replaced the bulky deployment using Ansible with OpenTofu followed by FluxCD. GitOps is cool.

- [Talos Linux](https://github.com/siderolabs/talos)
- [Proxmox](https://www.proxmox.com/en/)
- [OpenTofu](https://github.com/opentofu/opentofu)
- [Flux](https://github.com/fluxcd/flux2)
- [bpg/terraform-proxmox-provider](https://github.com/bpg/terraform-provider-proxmox)
- [integrations/terraform-provider-github](https://github.com/integrations/terraform-provider-github)
- [fluxcd/terraform-provider-flux](https://github.com/fluxcd/terraform-provider-flux)
- [siderolabs/terraform-provider-talos](https://github.com/siderolabs/terraform-provider-talos)

 ## Getting Started

This is just TL;DR explanation on how to install the project. For more information visit [docs](https://github.com/hiimluck3r/h3m/tree/main/docs).

 ### Prerequisites
1. Install OpenTofu (recommended) or Terraform.

2. Clone the repository:

    ```bash
    git clone https://github.com/hiimluck3r/h3m
    ```

    Or if you're so brave to use unstable dev build:

    ```bash
    git clone -b dev https://github.com/hiimluck3r/h3m
    ```

    Then initialize OpenTofu/Terraform with:
    ```bash
    tofu init
    ```
    or
    ```bash
    terraform init
    ```
 ### Configuration and Installation


1. Get a GitHub PAT. You can find a guide [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).

2. Create terraform.tfvars:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
3. Enter your information into .tfvars file:
    ```ini
    #This is an example from terraform.tfvars.example
    proxmox_user = "root@pam"
    proxmox_password = "12345678"
    proxmox_endpoint = "https://your_proxmox_endpoint:8006/"

    github_owner = "YOURNAME"
    github_pat = "github_pat_token"
    github_repository = {
      name = "h3m-flux" #make sure you don't have repo with the same name
      description = "Homelab built with Talos on Proxmox and managed with Flux"
      visibility = "private" #optional, but it's recommended
    }

    cluster_autostart = true
    cluster_endpoint = "192.168.0.10" #use the same value in patches/vip.yaml
    cluster_name = "talos-proxmox-cluster"

    node_name = "pve"
    default_bridge = "vmbr0"
    cidr = "192.168.0.20/29" #may be used in initialization of the vm instead of dhcp
    gateway = "192.168.0.1" #may be used in initialization of the vm instead of dhcp

    image_storage = "local"
    image_type = "iso" #please use images with qemu, otherwise you'll have to manually cleanup this badness and collect ip addresses
    talos_image_url = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.7.0/nocloud-amd64.iso"
    talos_flavor = "factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.7.0"

    disk_config = {
      datastore_id = "local-zfs"
      interface = "scsi0"
      iothread = false
      discard = "on"
    }

    master_config = {
      count = 3
      cpus = 2
      sockets = 1
      memory = 4096 #MB
      disk_size = 20 #GB
    }

    worker_config = {
      count = 2
      cpus = 2
      sockets = 1
      memory = 4096 #MB
      disk_size = 20 #GB
    }
    ```
4. Also configure VIP patch in patches/vip.yaml if needed:
    ```yaml
    ---
    machine:
    network:
        interfaces:
        - interface: eth0
            vip:
            ip: 192.168.0.10 #<- Please configure it if you're using VIP, othervise - delete patch in talos.tf configuration for control-plane (master) node
    ```
5. Plan and apply:
    ```bash
    tofu plan
    tofy apply
    ```
 ## Usage

Usually the cluster takes about 10 minutes to load. You can get talosconfig and kubeconfig in the "configs/" directory in the root of the project.

 ## Roadmap

* Provide understandable documentation
* Provide more examples for cluster-examples
* Provide an external repository with a list of app and deployments that I use
* Cilium integration? I guess I'll try it?

See the [open issues](https://github.com/hiimluck3r/h3m/issues) for a full list of proposed features (and known issues).

 ## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
 
 ## License

Distributed under the MIT License. See [MIT License](https://opensource.org/licenses/MIT) for more information.
 
 ## Contact

* VK: [@hiimluck3r](https://vk.com/hiimluck3r)
* Telegram Channel: [@imluck3r](https://t.me/imluck3r)
