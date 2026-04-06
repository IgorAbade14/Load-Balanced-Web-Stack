variable "aws_region" {
  description = "AWS Region (e.g., us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "ami_ubuntu" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-0c7217cdde317cfec"
}


variable "environment" {
  description = "Ambiente de desenvolvimento (produção ou dev)"
  type        = string
  default     = "dev"

}