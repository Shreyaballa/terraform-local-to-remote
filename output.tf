output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "uploaded_pdf_path" {
  value = "/home/ubuntu/document.pdf"
}
