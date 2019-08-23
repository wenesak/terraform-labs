variable "loc" {
    description = "Default Azure region"
    default     =   "centralus"
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}