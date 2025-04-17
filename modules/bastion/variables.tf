# Metadata-related variables
variable "project_id" {
  type        = string
  description = "ID of the project in which the bastion VM will be deployed."
}

variable "name" {
  type        = string
  description = "Name to give the bastion VM."
}

variable "region" {
  type        = string
  description = "Region to deploy the bastion in."
}

variable "labels" {
  type        = map(string)
  description = "Labels to add to the bastion VM."
  default     = {}
}

# Machine-related variables
variable "machine_type" {
  type        = string
  description = "The machine type for bastion instance."
  default     = "e2-micro"
}

# Network-related variables
variable "network_self_link" {
  type        = string
  description = "Network self_link used for firewall configuration."
}

variable "subnet_self_link" {
  type        = string
  description = "Subnet self_link in which the bastion VM will be deployed."
}

variable "tags" {
  type        = list(string)
  description = "Network tags to add to the bastion VM."
  default     = []
}

# IAM-related variables
variable "members" {
  type        = list(string)
  description = "List of members inside the organization that can connect to the bastion VM through IAP."
  default     = []
}

# Connection-related variables
variable "two_factor" {
  type        = bool
  description = "Enable the 2FA option to connect to bastion instance."
  default     = true
}

# Service Account email
variable "service_account_email" {
  type        = string
  description = "Email address associated with the bastion service account"
  default     = null
}

# Service Account scopes
variable "service_account_scopes" {
  type        = list(string)
  description = "List of service scopes allowed for the bastion instance"
  default     = ["cloud-platform"]
}

# Automated patching
variable "enable_automated_patching" {
  type        = bool
  description = "Enable to run a weekly apt-get upgrade on the bastion instance"
  default     = true
}
