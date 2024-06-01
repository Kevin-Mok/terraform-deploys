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
  name         = "bpatrik/pigallery2"
  keep_locally = true
}

resource "docker_image" "hemmelig" {
  name         = "hemmeligapp/hemmelig"
  keep_locally = true
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

resource "docker_container" "hemmelig" {
  image = docker_image.hemmelig.image_id
  name  = "hemmelig"
  env   = ["SECRET_LOCAL_HOSTNAME=0.0.0.0", "SECRET_PORT=3000"]

  ports {
    internal = 3000
    external = 8002
  }

  volumes {
    container_path  = "/var/tmp/hemmelig/upload/files"
    read_only = false
    host_path = "/home/kevin/coding/hemmelig/data"
  }

  volumes {
    container_path  = "/home/node/hemmelig/database/"
    read_only = false
    host_path = "/home/kevin/coding/hemmelig/database"
  }
}
