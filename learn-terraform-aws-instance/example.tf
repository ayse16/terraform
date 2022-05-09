
# # New resource for the S3 bucket our application will use.
# resource "aws_s3_bucket" "my-s3" {
#   # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
#   # this name must be changed before applying this example to avoid naming
#   # conflicts.
#   bucket = "ayse-terraform-guide"

# }



# resource "aws_instance" "example-1" {
#   ami = "ami-0c02fb55956c7d316"
#   instance_type = "t2.micro"
#   provisioner "local-exec" {
#     command = "echo ${aws_instance.example-1.public_ip} > ip_address.txt"
#   }
# }
# resource "aws_instance" "example" {
#   ami = "ami-0c02fb55956c7d316"
#   instance_type = "t2.micro"

#   # Tells Terraform that this EC2 instance must be created only after the
#   # S3 bucket has been created.
#   depends_on = [aws_s3_bucket.my-s3]

# }
# provider "aws" {
#  region = var.test
# }

# resource "aws_instance" "yeni" {
#   ami = "ami-0c02fb55956c7d316"
#   instance_type = "t2.micro"
# }

# output "ami" {
#   value = aws_instance.example.ami
# }


