#!/bin/bash
# Purpose: upload a directory of DICOMs to Orthanc.

if ! [ -d "$1" ]; then
  echo "Must give a directory of DICOM files."
  exit 1
fi

user_json="$(oc -n hosting-of-medical-image-analysis-platform-dcb83b get secret orthanc-user -o jsonpath='{.data}')"
if [ "$?" != '0' ]; then
  echo "error getting secret 'orthanc-user' from OpenShift. Are you logged in?"
  exit 1
fi
username="$(echo "$user_json" | jq -r .username | base64 -d)"
password="$(echo "$user_json" | jq -r .password | base64 -d)"

url="https://orthanc.chrisproject.org/instances"

find -L "$1" -type f -name '*.dcm' \
  | parallel --bar --eta -j1 "curl -sSfX POST -u \"$username:$password\" \"$url\" -H 'Expect:' -H 'Content-Type: application/dicom' -T {} -o /dev/null"
