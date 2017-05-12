provider "aws" {
  access_key = "AKIAJCJUHCVUDEP4KBKQ"
  secret_key = "6Six+UuBdum22LKsedUfusBSi+lWeApq+01Q/WpO"
  region     = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-618fab04"
  instance_type = "t2.micro"
  key_name = "SaltStack"
  security_groups = ["launch-wizard-3"]
  tags {
    Name = "ServerSpec-terraform"
  }
  
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update","sudo apt-get -y install tomcat8","sudo apt-get -y install tomcat8-admin","sudo apt-get -y install tomcat8-docs","sudo apt-get -y install tomcat8-common","sudo apt-get -y install tomcat8-examples","sudo apt-get -y install tomcat8-user","sudo apt-get install --fix-missing"
    ]
	
	connection {
               type     = "ssh"
			   host = "${aws_instance.example.public_ip}"
			   private_key  = "${file("SaltStack.pem")}"
			   port="22"
               user = "ubuntu"
               timeout = "1m"

        }
  }
  
  
  	provisioner "file" {
    source      = "files"
    destination = "/tmp"
	
	connection {
               type     = "ssh"
			   host = "${aws_instance.example.public_ip}"
			   private_key  = "${file("SaltStack.pem")}"
			   port="22"
               user = "ubuntu"
               timeout = "1m"

        }

  }
  
  
   provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/files/TestRestWebservice.war /var/lib/tomcat8/webapps/TestRestWebservice.war","sudo cp /tmp/files/tomcat-users.xml /etc/tomcat8/tomcat-users.xml","sudo service tomcat8 restart"
    ]
	
	connection {
               type     = "ssh"
			   host = "${aws_instance.example.public_ip}"
			   private_key  = "${file("SaltStack.pem")}"
			   port="22"
               user = "ubuntu"
               timeout = "1m"

        }

  }

provisioner "local-exec" {
    command ="export TARGET_HOST=${aws_instance.example.public_ip}"

  }
  
}