resource "github_repository" "this" {
  depends_on = [ time_sleep.wait_until_bootstrap ]
  name = var.github_repository.name
  description = var.github_repository.description
  visibility = var.github_repository.visibility
  auto_init = true
}

resource "flux_bootstrap_git" "this" {
  depends_on = [
    github_repository.this
  ]

  embedded_manifests = false
  path               = format("clusters/%s", var.cluster_name)
}