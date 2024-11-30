provider "aws" {
  region = "ap-south-1"
}

resource "aws_db_instance" "my_rds" {
  identifier              = "my-db-instance"
  allocated_storage       = 20
  instance_class          = "db.t3.micro" 
  engine                  = "mysql"
  engine_version          = "8.0"
  db_name                 = "mydatabase"
  username                = "admin"
  password                = "password123"
  publicly_accessible     = false
  skip_final_snapshot     = true
  
}



resource "null_resource" "db_initializer" {
  depends_on = [aws_db_instance.my_rds]

  provisioner "local-exec" {
    command = <<EOT
mysql -h ${aws_db_instance.my_rds.address} \
      -u admin \
      -ppassword123 \
      -e "source ./initialize_db.sql"
EOT
  }

  triggers = {
    db_instance_id = aws_db_instance.my_rds.id
  }
}