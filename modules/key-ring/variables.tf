variable "key_ring_name" {
  description = "The name of the key ring to create"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The project ID where the key ring should be created / exists"
  type        = string
}

variable "key_ring_location" {
  description = "The location of the key ring"
  type        = string
}

variable "existing_key_ring_name" {
  description = "The name of a key ring that already exists"
  type        = string
  default     = ""
}
