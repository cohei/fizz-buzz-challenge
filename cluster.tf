provider "google" {
  credentials = "${file("account.json")}"
  project     = "fizz-buzz-challenge"
  region      = "asia-northeast1"
  zone        = "asia-northeast1-b"
}

resource "google_container_cluster" "executor" {
  name               = "executor"
  initial_node_count = 1
}
