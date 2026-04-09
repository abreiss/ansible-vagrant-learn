data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "runner" {
  name        = "github-runner-sg"
  description = "Security group for GitHub Actions self-hosted runner"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "github-runner-sg"
  })
}

resource "aws_key_pair" "runner" {
  key_name   = var.key_name
  public_key = var.ssh_public_key

  tags = local.common_tags
}

resource "aws_instance" "runner" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.runner.key_name
  vpc_security_group_ids = [aws_security_group.runner.id]

  tags = merge(local.common_tags, {
    Name = "github-runner"
  })
}

resource "null_resource" "ansible_provisioner" {
  depends_on = [aws_instance.runner]

  # Wait for SSH to become available before running Ansible
  connection {
    type        = "ssh"
    host        = aws_instance.runner.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'SSH ready'"]
  }

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i '${aws_instance.runner.public_ip},' \
        -u ubuntu \
        --private-key '${var.ssh_private_key_path}' \
        -e 'runner_token=${var.runner_token}' \
        -e 'github_repo=${var.github_repo}' \
        -e 'runner_name=${var.runner_name}' \
        -e 'runner_labels=${var.runner_labels}' \
        '${path.module}/../playbook.yml'
    EOT
  }
}
