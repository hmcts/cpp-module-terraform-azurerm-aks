variable "vault_ssh_key_path_private" {
  type = string
}

variable "vault_ssh_key_path_public" {
  type = string
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh.private_key_pem
  filename = "./private_ssh_key"
}

resource "vault_generic_secret" "ssh_private_key" {
  path = var.vault_ssh_key_path_private

  data_json = jsonencode({
    value = tls_private_key.ssh.private_key_pem
  })
}

resource "vault_generic_secret" "ssh_public_key" {
  path = var.vault_ssh_key_path_public

  data_json = jsonencode({
    value = tls_private_key.ssh.public_key_openssh
  })
}

output "public_ssh_key" {
  value = tls_private_key.ssh.public_key_openssh
}