variable "loc" {
    description = "Default Azure region"
    default     =   "centralus"
}

variable "webapplocs" {
  description = "approve regions"
  type = "list"
  default = [ "centralus", "southcentralus", "northcentralus" ]
}


variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}