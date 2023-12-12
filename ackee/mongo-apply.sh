#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"
set -ex
cd "$HERE"

exec helm upgrade --install -n hosting-of-medical-image-analysis-platform-dcb83b -f mongo-values.yaml ackee-db bitnami/mongodb --version 14.4.2
