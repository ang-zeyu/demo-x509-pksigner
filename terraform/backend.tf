terraform {
  backend "s3" {
    bucket = "signedpkmap-tfstate"
    key    = "signedpkmap.tfstate"
    region = "ap-southeast-1"
  }
}
