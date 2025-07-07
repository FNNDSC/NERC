#!/bin/bash -e
# Purpose: list all Patient MRNs inside Orthanc

set -o pipefail

user_json="$(oc -n hosting-of-medical-image-analysis-platform-dcb83b get secret orthanc-user -o jsonpath='{.data}')"
if [ "$?" != '0' ]; then
  echo "error getting secret 'orthanc-user' from OpenShift. Are you logged in?"
  exit 1
fi
username="$(echo "$user_json" | jaq -r .username | base64 -d)"
password="$(echo "$user_json" | jaq -r .password | base64 -d)"

url="https://orthanc.chrisproject.org/patients"

curl -sfu "$username:$password" "$url" \
  | jaq -r ".[]" \
  | xargs -I '{}' curl -sfu "$username:$password" "$url/{}" \
  | jaq -r '.MainDicomTags.PatientID'
