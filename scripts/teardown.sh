#!/usr/bin/env bash

echo -e "===============================>"
echo -e "Destroying application"
set -xe
source "shell-functions.sh"
Usage "$@"
shellVariables $1 $2 $3
greenfieldDestroy application
