#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"

# Check for chrisomatic.yml
#################
chrisomatic_file="$(realpath "$HERE/../chrisomatic.yml")"

if ! [ -f "$chrisomatic_file" ]; then
  echo "error: $chrisomatic_file is not a file"
  exit 1
fi

# Get superuser credentials from OpenShift
#################
secret_json="$(oc get secret cube1-chris-superuser -o jsonpath='{.data}')"
if [ "$?" != "0" ]; then
  echo "could not get secret from OpenShift. Are you logged in?"
  exit 1
fi

username="$(echo "$secret_json" | jq -r .username | base64 -d)"
password="$(echo "$secret_json" | jq -r .password | base64 -d)"

# Should I use Podman or Docker?
#################
if which podman > /dev/null 2>&1; then
  docker=podman
  if [ "$(podman info --format '{{ .Host.RemoteSocket.Exists }}')" = 'true' ]; then
    sock="$(podman info --format '{{ .Host.RemoteSocket.Path }}')"
  fi
elif which docker > /dev/null 2>&1; then
  docker=docker
  sock=/var/run/docker.sock
else
  echo "please install Podman or Docker."
  exit 1
fi

sock_arg=
if [ -n "$sock" ]; then
  sock_arg="-v $sock:/var/run/docker.sock:rw"
fi

# Run chrisomatic!
#################
set -ex

exec $docker run --rm -it --security-opt label=disable $sock_arg \
    -e CHRIS_USERNAME="$username" \
    -e CHRIS_PASSWORD="$password" \
    -v "$chrisomatic_file:/chrisomatic.yml:ro" \
    ghcr.io/fnndsc/chrisomatic:0.8.1 chrisomatic "$@"
