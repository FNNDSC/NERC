#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"
set -ex
cd "$HERE"
exec helm upgrade --install -n hosting-of-medical-image-analysis-platform-dcb83b -f values.yaml ohif fnndsc/ohif --version 0.1.1
