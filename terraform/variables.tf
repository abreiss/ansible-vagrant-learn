variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "github_repo" {
  description = "GitHub repository (owner/repo) to register the runner against"
  type        = string
  default     = "abreiss/ansible-vagrant-learn"
}

variable "instance_type" {
  description = "EC2 instance type for the GitHub Actions runner"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair to create"
  type        = string
  default     = "github-runner-key"
}

variable "runner_labels" {
  description = "Comma-separated labels to apply to the GitHub Actions runner"
  type        = string
  default     = "ec2"
}

variable "runner_name" {
  description = "Display name for the GitHub Actions runner"
  type        = string
  default     = "ec2-runner"
}

variable "runner_token" {
  description = "GitHub Actions runner registration token"
  type        = string
  sensitive   = true
}

variable "ssh_private_key_path" {
  description = "Absolute path to the SSH private key used by Ansible to connect to the instance"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key material to import as an AWS key pair"
  type        = string
}
