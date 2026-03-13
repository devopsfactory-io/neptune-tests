stack {
  name       = "apps/api"
  depends_on = ["platform/compute", "platform/storage"]
}
