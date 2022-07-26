#!/usr/bin/env bash

set -e

source shell-functions.sh
Usage "$@"
shellVariables $1 $2
echo -e "setting up initial variables"
echo -e "===============================================================>>>>>>>>"
echo -e "WARNING : The bootstrap buckets can not be deleted once created."
echo -e "===============================================================>>>>>>>>"
bootstrap bootstrap
echo -e "When you make a change to bootstrap please make sure to \
  download and upload the state to remote state. \
  This is a classic case of CHICKEN AND EGG"
#uploadFileS3