provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "flask_app" {
  metadata {
    name = "flask-app"
    labels = {
      app = "flask"
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          image = var.image_name
          name  = "flask"
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask_service" {
  metadata {
    name = "flask-service"
  }

  spec {
    selector = {
      app = "flask"
    }

    type = "NodePort"

    port {
      port        = 80
      target_port = 8000
      node_port   = var.node_port
    }
  }
}
