variable "environment" {
  type = list(string)
  default = [ "dev", "beta", "prod" ]
  description = "environment (aka k8s namespace)"
}