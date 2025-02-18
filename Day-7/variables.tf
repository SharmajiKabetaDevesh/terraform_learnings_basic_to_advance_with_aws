variable "allowed_locations"{
    type=list(string)
    default = [ "Central India","East US","West US" ]
}

variable "tobedestroyed_or_not"{
    type=bool
    default=true
}
variable "storage_size"{
    type=number
    default=30
}

variable "replication_type"{
    type=string
    default="LRS"
}
variable "storage_account_name"{
    type=list(string)
    default = [ "devtest1106","devtest1107" ]
}