variable "user_object_id" {
  description = "El Object ID del usuario de Azure AD que será el Officer"
  type        = string
}


variable "resource_group_location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "subnet_id" {
  type        = string
}
