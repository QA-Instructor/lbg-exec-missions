variable "projectid" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "zone" {
  type=string
  default = "europe-west1-c"
}

variable "maxnodecount" {
    type = number
    default = 4
}

variable "minnodecount" {
    type = number
    default = 1
}


variable "credentialfile" {
  type = string
}

variable "delegatecount" {
  type = number
}