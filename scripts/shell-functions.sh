#!/usr/bin/env bash


function Usage() {
    if [ "$#" -ne 3 ]; then
        echo "$@"
        echo "Illegal number of parameters"
        echo -e "\n====================================================>"
        echo -e "Usage: ./<script-name> <values-file values folder> <region> <environment>\n"
        echo -e "Region must be an AWS region and must be present in the environments/application directory"
        echo -e "\n====================================================>"
        exit 1
    fi
}

# shellcheck disable=SC2120
function terraform_backend_init() {
    type=$1
    if [[ ${type} == "bootstrap" ]]; then
      terraform init
    elif [[ ${type} == "application" ]]; then
      terraform init -backend-config="${VALUES_DIR}/${environment}-backend.conf"
    else
      echo -e "Not a valid deployment type"
      exit 1
    fi
}


function terraform_lc() {
    type=$1
    echo $type
    if [[ ${type} == "bootstrap" ]]; then
      terraform plan && \
      terraform apply --auto-approve
    elif [[ ${type} == "application" ]]; then
      terraform plan -var-file="${VALUES_DIR}/${environment}.tfvars" && \
      terraform apply -var-file="${VALUES_DIR}/${environment}.tfvars" --auto-approve
    else
      echo -e "Not a valid deployment type"
      exit 1
    fi
}

function terraform_lc_destroy() {
    type=$1
    echo $type
    if [[ ${type} == "bootstrap" ]]; then
      terraform plan -destroy&& \
      terraform apply -destroy --auto-approve
    elif [[ ${type} == "application" ]]; then
      terraform plan -destroy -var-file="${VALUES_DIR}/${environment}.tfvars" && \
      terraform apply -destroy -var-file="${VALUES_DIR}/${environment}.tfvars" --auto-approve
    else
      echo -e "Not a valid deployment type"
      exit 1
    fi
}

function terraformWorkspace() {
    echo -e "checking existing terraform workspace"
    exist=$(terraform workspace list | grep ${environment}  || true)
    if [[ -z ${exist} ]]; then
      echo -e "workspace does not exist. Creating..."
      terraform workspace new ${environment}
    fi
    terraform workspace select ${environment}
}

function build_application_binary() {
    cd $APPLICATION_BINARY
    env GOOS=linux GOARCH=amd64 go build -o ../bin/hello
}


# shellcheck disable=SC2120
function shellVariables() {
    declare -A props
    file=$1
    region=$2
    environment=$3

    echo $1 $2 $3
    export HOME_DIR=$(pwd)
    export BOOTSTRAP_DIR=${HOME_DIR}/../infrastructure/environments/bootstrap
    export APP_DIR=${HOME_DIR}/../infrastructure/environments/application/${region}
    export VALUES_DIR=${HOME_DIR}/../infrastructure/environments/values
    export APPLICATION_BINARY=${HOME_DIR}/../application/hello-world
}
function bootstrap() {
      deployment_type=$1
      echo -e "Running bootstrap\n"
      echo -e "Is this your first execution answer: y/n"
      read first_exec

      if [[ ${first_exec} == "y" ]]; then
          cd $BOOTSTRAP_DIR || exit
          terraform_backend_init ${deployment_type}
          terraform_lc ${deployment_type}
      fi
}
function greenfield() {
    deployment_type=$1
    echo -e "Checking AWS environment variables"

    if [[ x"${AWS_ACCESS_KEY_ID}" == "x" ]] || [[ x"${AWS_SECRET_ACCESS_KEY}" == "x" ]] || [[ x"${AWS_DEFAULT_REGION}" == "x" ]]; then
      echo -e "environment variable not set, \n we recommend using tool awsume ."
      echo -e "To install: pip/pip3 install awsume"
      # shellcheck disable=SC2016
      echo -e 'to set creds:  eval $(awsume -s <profile_name>)'
      exit 1
    fi

    cd $APP_DIR
    terraform_backend_init ${deployment_type}
    terraformWorkspace
    terraform_lc ${deployment_type}
}


function greenfieldDestroy() {
        deployment_type=$1
        echo -e "Checking AWS environment variables"

        if [[ x"${AWS_ACCESS_KEY_ID}" == "x" ]] || [[ x"${AWS_SECRET_ACCESS_KEY}" == "x" ]] || [[ x"${AWS_DEFAULT_REGION}" == "x" ]]; then
          echo -e "environment variable not set, \n we recommend using tool awsume ."
          echo -e "To install: pip/pip3 install awsume"
          # shellcheck disable=SC2016
          echo -e 'to set creds:  eval $(awsume -s <profile_name>)'
          exit 1
        fi
        cd $APP_DIR
        terraform_backend_init ${deployment_type}
        terraformWorkspace
        terraform_lc_destroy ${deployment_type}
}
#function uploadFileS3() {
#    set -xv
#    aws s3 cp "${BOOTSTRAP_DIR}"/terraform.tfstate s3://"${stateBucket}"/bootstrap/bootstrap.tfstate
#}

