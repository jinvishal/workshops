packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "k3s_version" {
  type    = string
  default = "v1.22.4+k3s1"
}

variable "gloo_version" {
  type    = string
  default = "1.8.18"
}

variable "glooee_version" {
  type    = string
  default = "1.8.15"
}

source "googlecompute" "k3s" {
  project_id   = "solo-test-236622"
  region       = "us-central1"
  zone         = "us-central1-a"

  image_storage_locations = [ "us" ]
  image_family = "workshop-instruqt-gloo-edge"
  image_name   = regex_replace("workshop-instruqt-gloo-edge-${var.glooee_version}-k3s-${var.k3s_version}-${formatdate("YYYYMMDD", timestamp())}", "[^a-zA-Z0-9_-]", "-")
  image_labels = {
      builder = "packer"
  }
      
  metadata = {
    enable-oslogin = "FALSE"
  }

  source_image_family = "ubuntu-2110"

  machine_type = "n1-standard-8"
  disk_size    = 20
  disk_type    = "pd-balanced"

  ssh_username = "root"

  tags = ["packer"]
}

build {
    sources = ["source.googlecompute.k3s"]

    provisioner "shell" {
        script = "files/k3s-install.sh"
        environment_vars = [
            "K3S_VERSION=${ var.k3s_version }"
        ]
    }

    provisioner "file" {
        source      = "files/package.json"
        destination = "/root/package.json"
    }

    provisioner "shell" {
        script = "files/node-install.sh"
        environment_vars = [
            "K3S_VERSION=${ var.k3s_version }"
        ]
    }

    provisioner "file" {
        sources = [
            "files/k3s.service",
            "files/kubectl-proxy.service",
        ]
        destination = "/etc/systemd/system/"
    }

    provisioner "file" {
        source      = "files/k3s-start.sh"
        destination = "/usr/local/bin/k3s-start.sh"
    }

    provisioner "file" {
        source      = "files/start.sh"
        destination = "/usr/bin/start.sh"
    }

    provisioner "shell" {
        script = "files/import-docker-images.sh"
        environment_vars = [
            "GLOOEE_VERSION=${ var.glooee_version }",
            "GLOO_VERSION=${ var.gloo_version }"
        ]
    }
}
