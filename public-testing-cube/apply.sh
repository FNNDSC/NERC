#!/bin/bash

HERE="$(dirname "$(readlink -f "$0")")"
set -ex
cd "$HERE"
exec helm upgrade -n hosting-of-medical-image-analysis-platform-dcb83b -f values.yaml public-testing fnndsc/chris --version 0.8.0
