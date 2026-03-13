terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "stack_name" {
  type = string
}

resource "null_resource" "stack" {
  triggers = {
    stack = var.stack_name
  }
}

resource "local_file" "output" {
  content  = "${var.stack_name} deployed"
  filename = "${path.module}/output.txt"
}
