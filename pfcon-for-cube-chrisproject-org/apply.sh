#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"
set -ex
cd "$HERE"
exec helm upgrade -n hosting-of-medical-image-analysis-platform-dcb83b -f values.yaml acpo-only fnndsc/pfcon --version 0.1.1
