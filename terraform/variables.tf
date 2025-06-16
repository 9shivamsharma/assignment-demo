variable "image_name" {
  description = "Docker image for the Flask app"
  type        = string
  default     = "shivam432000/flask-hello-world:latest"
}

variable "replica_count" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 2
}

variable "node_port" {
  description = "NodePort to expose the service"
  type        = number
  default     = 30036
}
