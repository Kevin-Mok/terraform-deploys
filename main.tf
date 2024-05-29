terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "pigallery" {
  name = "bpatrik/pigallery2"
}

resource "docker_container" "pigallery" {
  image = docker_image.pigallery.image_id
  name  = "pigallery"

  ports {
    internal = 80
    external = 8001
  }

  volumes {
    container_path  = "/app/data/config"
    read_only = false
    host_path = "/home/kevin/coding/pigallery/images/"
  }

  volumes {
    container_path  = "/app/data/db"
    read_only = false
    host_path = "/home/kevin/coding/pigallery/db-data/"
  }

  volumes {
    container_path  = "/app/data/images"
    read_only = true
    host_path = "/home/kevin/coding/pigallery/images/"
  }

  volumes {
    container_path  = "/app/data/tmp"
    read_only = false
    host_path = "/home/kevin/coding/pigallery/tmp/"
  }
}
