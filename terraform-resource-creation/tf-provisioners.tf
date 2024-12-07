resource "null_resource" "create_partition" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.vm_public_ip.ip_address
      user        = "adminuser"
      private_key = file("~/.ssh/id_rsa")
    }
    script = "./disk-mnt-script.sh"
  }
 
  # Use a trigger to force re-execution of the provisioner
  triggers = {
    always_run = "${timestamp()}"
  }
}
