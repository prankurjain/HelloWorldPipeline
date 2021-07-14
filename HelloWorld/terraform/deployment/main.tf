resource "aws_instance" "backend1" {
  ami               = "ami-00399ec92321828f5"
  instance_type     = "t2.micro"
  key_name          = var.key_name
  vpc_security_group_ids = [var.sg_id]
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "HelloWorld1"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.pvt_key_name)
    host  = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo sleep 30",
      "sudo apt-get update -y",
      "sudo apt-get install python openssh-server -y"
    ]

  }
}


resource "null_resource" "ansible-main1" {
  provisioner "local-exec" {
    command = <<EOT
       > jenkins-ci.ini;
       echo "[jenkins-ci]"|tee -a jenkins-ci.ini;
       export ANSIBLE_HOST_KEY_CHECKING=False;
       echo "${aws_instance.backend1.public_ip}"|tee -a jenkins-ci.ini;
       chmod 400 ${var.pvt_key_name}
       ansible-playbook --key-file=${var.pvt_key_name} -i jenkins-ci.ini -u ubuntu ./../../ansible-code/helloworld.yaml -vvv
     EOT
  }
  depends_on = [aws_instance.backend1]
}





resource "aws_instance" "backend2" {
  ami               = "ami-00399ec92321828f5"
  instance_type     = "t2.micro"
  key_name          = var.key_name
  vpc_security_group_ids = [var.sg_id]
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "HelloWorld2"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.pvt_key_name)
    host  = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo sleep 30",
      "sudo apt-get update -y",
      "sudo apt-get install python openssh-server -y"
    ]

  }
}


resource "null_resource" "ansible-main2" {
  provisioner "local-exec" {
    command = <<EOT
       > jenkins-ci2.ini;
       echo "[jenkins-ci2]"|tee -a jenkins-ci2.ini;
       export ANSIBLE_HOST_KEY_CHECKING=False;
       echo "${aws_instance.backend2.public_ip}"|tee -a jenkins-ci2.ini;
       chmod 400 ${var.pvt_key_name}
       ansible-playbook --key-file=${var.pvt_key_name} -i jenkins-ci2.ini -u ubuntu ./../../ansible-code/helloworld.yaml -vvv
     EOT
  }
  depends_on = [aws_instance.backend2]
}


