#!/bin/bash

user_json="$(oc get secret orthanc-user -o jsonpath='{.data}')"
if [ "$?" != '0' ]; then
  echo "error getting secret 'orthanc-user' from OpenShift. Are you logged in?"
  exit 1
fi
username="$(echo "$user_json" | jaq -r .username | base64 -d)"
password="$(echo "$user_json" | jaq -r .password | base64 -d)"

HERE="$(dirname "$(readlink -f "$0")")"
set -ex
cd "$HERE"

exec helm upgrade -n hosting-of-medical-image-analysis-platform-dcb83b \
    -f values.yaml \
    --set "orthanc.config.registeredUsers.$username=$password" \
    cube1 fnndsc/chris --version 0.13.0
