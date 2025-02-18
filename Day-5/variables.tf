variable "environment"{
    type=string
    description = "value of environment"
    default="dev"
}

variable "location"{
    type=string
    description = "location of environment"
    default="Central India"
}
variable "storage_size"{
    type=number
    default=30
}

variable "allowed_location" {
    type=list(string)
    description = "locations that can be used to create resources"
    default=["Central India","East US","West US"]
  
}
variable "resource_tags"{
    type=map(string)
    description = "value of tags"
    default={
        "environment"="staging"
        "managed_by"="terraform"
        department="devops"
    }
}
variable "permanent"{
    type=tuple(string)
    default=["devops","terraform"]
}
variable "vm_sizes_set_db"{
    type=set(string)
    default=["Standard_B1s","Standard_B1ms","Standard_B2s"]
}
variable "obj_test" {
   type=object({
         name=string
         age=number
   })
   default={
         name="test"
         age=20
   }
}