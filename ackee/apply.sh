#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"
set -ex
cd "$HERE"

exec helm upgrade -n hosting-of-medical-image-analysis-platform-dcb83b -f values.yaml ackee ./suda-charts/charts/ackee --version 0.2.1
