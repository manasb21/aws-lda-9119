#!/usr/bin/env bash
set -xe
source "shell-functions.sh"
Usage "$@"
shellVariables $1 $2 $3
echo -e "SETTING UP THE INFRASTRUCTURE"
build_application_binary
greenfield application

