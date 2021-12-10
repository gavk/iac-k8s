terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}

# Profiles
resource "lxd_profile" "master" {
  config = {
    "limits.cpu"    = 2
    "limits.memory" = "3GB"
  }
  description = "LXD profile for master nodes"
  name        = "master"
}

resource "lxd_profile" "worker" {
  config = {
    "limits.cpu"    = 2
    "limits.memory" = "4GB"
  }
  description = "LXD profile for worker nodes"
  name        = "worker"
}

resource "lxd_cached_image" "ubuntu1804" {
  source_remote = "ubuntu"
  source_image  = "18.04"
}

resource "lxd_container" "master" {
  config    = {}
  count     = 1
  ephemeral = false
  name      = "master${count.index}"
  profiles = [
    "master", "default"
  ]
  image            = lxd_cached_image.ubuntu1804.fingerprint
  wait_for_network = false
}

resource "lxd_container" "worker" {
  config    = {}
  ephemeral = false
  name      = "worker${count.index}"
  count     = 2
  profiles = [
    "worker",
    "default",
  ]
  image            = lxd_cached_image.ubuntu1804.fingerprint
  wait_for_network = false
}
