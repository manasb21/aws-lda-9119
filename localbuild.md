# Local Build

<aside>
💡 Local build is designed to perform all actions automatically via execution of specific scripts in specific order, except for some initial configurations . Please read the instructions carefully. This example assumes that the developers have either Linux or macOS to perform all operations.

</aside>

- Install required tools on your local machine

You can use the below commands or you can refer to the links below for the latest ways to install them from the original providers.

```bash
brew install python3-pip
brew install go
pip3 install awsume awscli
brew install jq
```

- [ ]  python3-pip
- [ ]  go
- [ ]  awsume
- [ ]  awscli
- [ ]  jq
- [ ]  terraform
- [ ]  tfswitch

<aside>
📌 For the further steps we require to setup the AWS credentials either via aws cli or via environment variables. The code is designed to automatically pick the AWS environment variable set in the terminal. To easily achieve this , please follow below instructions.

</aside>

```bash
aws configure --profile ppro-lab
```

```bash
AWS Access Key ID [****************W2OU]: xxxx
AWS Secret Access Key [****************f1MV]:xxxx
Default region name [eu-central-1]: xxxx
Default output format [json]:xxxx
```

```bash
eval $(awsume -s ppro-lab)
```

<aside>
📌 To verify if all the environment variables have been set properly —>

</aside>

```bash
export -p | grep AWS
```

- Bootstrap

go to scripts directory 

```bash
└── scripts
    ├── application-deploy.sh
    ├── bootstrap-deploy.sh
    ├── shell-functions.sh
    └── teardown.sh
```

To initialize bootstrap resources for dev environment:

```bash
bash bootstrap-deploy.sh ../environments/values/dev.tfvars eu-central-1 dev
```

[bootstrap-deploy.sh](http://bootstrap-deploy.sh) takes 3 arguments  

$1 = the environment variables for the specific environment

$2 = the region where the initial setup is intended to be created. Based on the data, the S3 bucket for state and the dynamodb table is created for terraform state lock

$3 = environment which needs to be deployed

<aside>
📌 These buckets and dynamodb tables have a static name with the combination of its purpose and aws account context, which can be used in properties of the application right away.

</aside>

<aside>
📌 BOOTSTRAP deploy is one time activity. Once  a backend s3 bucket and dynamodb is created, it is recommended not to make changes manually to the dynamodb or s3 bucket.

</aside>

- Create the application environments

From the scripts directory

- To create the dev environment

```bash
bash application-deploy.sh ../infrastructure/environments/values/dev.tfvars \
eu-central-1 dev
```

- **application sample output**

- To create prod environment

```bash
bash application-deploy.sh ../infrastructure/environments/values/prod.tfvars \
eu-central-1 prod
```

<aside>
📌 WARNING:  The region provided in the script can not be different than the bootstrap region . i.e we can not provide 2 different values one for bootstrap and another for application , though it is technically possible.

</aside>

<aside>
📌 It also should be noted that we can not create any mentioned resources in AWS  in regions excluding eu-central-1 and eu-west-3. The validation has been set for the variables in the modules directory in all modules.  To see all validations see References section at the end of the readME.

</aside>

To destroy the whole application architecture:

```bash
bash teardown.sh ../infrastructure/environments/values/dev.tfvars \
eu-central-1 dev
```

To destroy bootstrap resources , please use either manual destroy or if you have tfstate , run terraform destroy keeping tfstate as local state file.