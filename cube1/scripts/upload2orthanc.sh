#!/bin/bash
# Purpose: upload a directory of DICOMs to Orthanc.
# For unknown reasons, this script is rather slow.

if ! [ -d "$1" ]; then
  echo "Must give a directory of DICOM files."
  exit 1
fi

user_json="$(oc get secret orthanc-user -o jsonpath='{.data}')"
if [ "$?" != '0' ]; then
  echo "error getting secret 'orthanc-user' from OpenShift. Are you logged in?"
  exit 1
fi
username="$(echo "$user_json" | jq -r .username | base64 -d)"
password="$(echo "$user_json" | jq -r .password | base64 -d)"

url="https://orthanc.chrisproject.org/instances"

files="$(find -L "$1" -type f -name '*.dcm')"
total="$(wc -l <<< "$files")"

echo "$files" \
  | tqdm --total=$total --unit=files --desc=Uploading \
  | xargs -I '{}' curl -sfX POST -u "$username:$password" "$url" \
      -H 'Expect:' -H 'Content-Type: application/dicom' --data-binary @'{}' -o /dev/null
