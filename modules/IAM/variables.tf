variable name {}

variable "userlist" {
  type = "list"
  default = []
}

variable "grouplist" {
  type = "list"
  default = []
}

variable "groupmembership" {
  type = "map"
  default = {}
}
