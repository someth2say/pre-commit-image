#! /bin/sh
function has() {
  curl -sL https://git.io/_has | bash -s $1
  return $?
}

has "podman" && command="podman" || has "docker" && command="docker"
$command build . -t quay.io/redhattraining/pre-commit -f Containerfile