stack {
  name       = "apps/worker"
  depends_on = ["platform/compute", "platform/storage"]
}
