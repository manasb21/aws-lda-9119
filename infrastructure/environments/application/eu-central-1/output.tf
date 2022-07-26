output "gateway" {
  value = {
    gateway_url = "${module.ppro-api-gw.base_url}/${var.context_root}"
  }
}