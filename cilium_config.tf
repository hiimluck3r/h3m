data "helm_template" "cilium_template" {
  name = "cilium"
  namespace = "kube-system"
  repository = "https://helm.cilium.io/"
  kube_version = "1.21.0-0"

  chart = "cilium"
  version = "1.16.0"

  include_crds = true

  values = [<<-EOF
    ipam:
      mode: kubernetes
    kubeProxyReplacement: true
    
    ingressController:
      enabled: true
      default: true
    
    gatewayAPI:
      enabled: true
      hostNetwork:
        enabled: false
      gatewayClass:
        create: "true"
      externalTrafficPolicy: "Local"

    envoy:
      enabled: true
      securityContext:
        capabilities:
          keepCapNetBindService: true
          envoy:
          # Add NET_BIND_SERVICE to the list (keep the others!)
          - NET_BIND_SERVICE
          - NET_ADMIN
          - SYS_ADMIN

    l2announcements:
      enabled: true
    l7Proxy: true

    securityContext:
      privileged: true
      capabilities:
        cleanCiliumState:
          - NET_ADMIN
          - SYS_ADMIN
          - SYS_RESOURCE2
        ciliumAgent:
          - CHOWN
          - KILL
          - NET_ADMIN
          - NET_RAW
          - IPC_LOCK
          - SYS_ADMIN
          - SYS_RESOURCE
          - DAC_OVERRIDE
          - FOWNER
          - SETGID
          - SETUID

    hubble:
      enabled: true
      metrics:
        enabled:
          - dns:query
          - drop
          - tcp
          - flow
          - port-distribution
          - icmp
          - http
      relay:
        enabled: true
        rollOutPods: true
      ui:
        enabled: false

    cgroup:
      autoMount:
        enabled: false
      hostRoot: /sys/fs/cgroup

    k8sServiceHost: localhost
    k8sServicePort: "7445"

    externalIPs:
      enabled: true
  EOF
  ]
}