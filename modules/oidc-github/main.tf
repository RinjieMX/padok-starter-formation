data "google_project" "project" {
  project_id = var.project_id
}

# Workload Identity pool for github
resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id != "" ? var.workload_identity_pool_id : "github"
}

locals {
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id != "" ? var.workload_identity_pool_provider_id : "${var.github_orga_name}-${var.github_repo_name}"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = local.workload_identity_pool_provider_id
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.actor"            = "assertion.actor"
  }
  # The condition can be defined: repository, repository_owner, branch, custom
  # If not defined, the default condition is repository=='${var.github_orga_name}/${var.github_repo_name}'
  attribute_condition = (
    var.attribute_condition != null ? (
      var.attribute_condition.type == "repository" ? (
        var.attribute_condition.value != null ?
        "assertion.repository=='${var.attribute_condition.value}'" :
        "assertion.repository=='${var.github_orga_name}/${var.github_repo_name}'"
        ) : (
        var.attribute_condition.type == "repository_owner" ? (
          var.attribute_condition.value != null ?
          "assertion.repository_owner=='${var.attribute_condition.value}'" :
          "assertion.repository_owner=='${var.github_orga_name}'"
          ) : (
          var.attribute_condition.type == "branch" ? (
            var.attribute_condition.value != null ?
            "assertion.ref=='${var.attribute_condition.value}'" :
            "assertion.ref=='refs/heads/main'"
            ) : (
            var.attribute_condition.type == "custom" ? (
              var.attribute_condition.value != null ?
              var.attribute_condition.value :
              "assertion.repository=='${var.github_orga_name}/${var.github_repo_name}'"
            ) : "assertion.repository=='${var.github_orga_name}/${var.github_repo_name}'"
          )
        )
      )
    ) :
    "assertion.repository=='${var.github_orga_name}/${var.github_repo_name}'"
  )

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
    allowed_audiences = [
      "https://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/providers/${local.workload_identity_pool_provider_id}"
    ]
  }
}

# Service account with access to Artifact Repository through workload identity to push images
resource "google_service_account" "github" {
  count = var.create_service_account ? 1 : 0

  project      = var.project_id
  account_id   = var.service_account_github_name
  display_name = "Service Account for Github"
}

locals {
  github_principal_set = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_orga_name}/${var.github_repo_name}"
}

resource "google_service_account_iam_binding" "sa_github_workloadidentity" {
  count = length(google_service_account.github)

  service_account_id = google_service_account.github[count.index].name
  role               = "roles/iam.workloadIdentityUser"

  members = [local.github_principal_set]
}
