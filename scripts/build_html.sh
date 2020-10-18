#! /usr/bin/env bash

# get the file directory
FILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT_DIR=$(dirname ${FILE_DIR})

cd ${ROOT_DIR}
make -C images/
make -C images/ cover.pdf
make html/index.html