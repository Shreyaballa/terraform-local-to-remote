# EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-00271c85bf8a52b84" # Ubuntu 20.04 AMI
  instance_type = "t2.micro"
  key_name      = "cal-key"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.vpc_security_group_id]

  user_data = <<-EOT
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl enable apache2
              systemctl start apache2
              EOT

  tags = {
    Name = "Terraform-EC2"
  }
}

# Upload PDF to EC2
resource "null_resource" "upload_pdf" {
  depends_on = [aws_instance.web]

  provisioner "file" {
    source      = "document.pdf"                  # Local PDF file
    destination = "/home/ubuntu/document.pdf"     # Remote path

    connection {
      type        = "ssh"
      host        = aws_instance.web.public_ip
      user        = "ubuntu"
      private_key = file("C:/Users/HP/Downloads/cal-key.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 644 /home/ubuntu/document.pdf",
      "ls -l /home/ubuntu/document.pdf"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.web.public_ip
      user        = "ubuntu"
      private_key = file("C:/Users/HP/Downloads/cal-key.pem")
    }
  }
}
