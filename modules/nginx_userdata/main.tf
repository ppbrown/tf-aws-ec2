
locals {
    fancy_user_data = templatefile("${path.module}/user_data.tmpl", {
  })
}

output "user_data" {
  value = local.fancy_user_data
}

