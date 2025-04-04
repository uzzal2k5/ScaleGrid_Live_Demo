resource "random_string" "suffix" {
  count = 2
  length  = 8
  special = false
  upper   = false
}
