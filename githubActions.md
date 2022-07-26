# Github Actions

Github Action pipeline leverages various opensource actions to perform the operations

The workflows are present in **.github/workflows** folder

terraform-ci.yml is the common workflow that is used in both dev and prod environments

dev-eu-central-1.yml is for dev environment in region eu-central-1

prod-eu-central-1.yml is for prod environment in region eu-central-1

These workflows can also be refactored to make it even more flexible. However for the sake of demo, it will become complex if refactored more.

when you push the code to branch dev dev-eu-central-1.yml will execute as shown below

similarly when you push code to prod branch prod-eu-central-1.yml 

For successful execution of the workflows, it is necessary to configure the credentials in settings—> security —> Actions —> Repository secrets of the git repository

workflows

![Screenshot 2022-07-26 at 17.15.59.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.15.59.png)

configure secrets

<aside>
📌 NOTE: the picture only shows 1 secret DEV_AWS_ACCESS_KEY , however  for the pipeline to run properly it needs all the secrets mentioned in the corresponding pipeline yml. For Prod env to work change the secret names prefix from DEV_AWS_ACCESS_KEY —> PROD_AWS_ACCESS_KEY . For security reasons, the full credentials are not configured in a public repository.

</aside>

![Screenshot 2022-07-26 at 17.19.29.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.19.29.png)

![Screenshot 2022-07-26 at 17.14.48.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.14.48.png)

![Screenshot 2022-07-26 at 17.15.43.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.15.43.png)

actions page in github workflow

![Screenshot 2022-07-26 at 17.13.47.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.13.47.png)

workflow stages & application

![Screenshot 2022-07-26 at 17.14.01.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.14.01.png)

After the terraform has been applied you will see a link on the output of the terraform apply screen as gateway_url.

![Screenshot 2022-07-26 at 17.14.28.png](Github%20Actions%20d2314b9c58a24c8c898b9f9077f3f696/Screenshot_2022-07-26_at_17.14.28.png)

[https://mzkqjkoauh.execute-api.eu-central-1.amazonaws.com/ppro-api-gw-dev-stage-dev/hello](https://mzkqjkoauh.execute-api.eu-central-1.amazonaws.com/ppro-api-gw-dev-stage-dev/hello)

when you click on it. it will fetch the string from dynamo db and show it to the end user.

<aside>
📌 NOTE: bootstrap is not executed via github actions. For boot strap execution please see local build. terraform destroy is also not part of github action , for terraform destroy of the application , please see local build.

</aside>