resource "aws_instance" "example" {
  ami           = "ami-0327f51db613d7bd2" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  key_name      = "my-key"
 

  tags = {
    Name = "ExampleInstance"
  }
}


resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("c:/Users/Hp/.ssh/id_rsa.pub") # Path to your public key
}

resource "null_resource" "install_apache" {
  depends_on = [aws_instance.example]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/Hp/.ssh/id_rsa") # Path to your private key
      host        = aws_instance.example.public_ip
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}