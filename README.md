# toalha_DevOps-Eng-test
#### [Source] https://github.com/philvadala/devops-tech-test/tree/main/Senior-DevOps-Engineer

This repo is a reply to the Source, where the objective was to provide a code that will provission supplied flask app on cloud container service.

## Approach
It uses Docker to create the image and then AWS ECR, ECS to provission the container. Here is a simple diagram of the AWS side

![alt text](https://github.com/Tosrif/toalha_DevOps-Eng-test/blob/main/diagram.png?raw=true)


## Components
This repo and the CI/CD pipeline has two components
1. **Docker:** It uses Docker in docker to create the required docker image and then publish it to the AWS ECR
2. **Terraform:** The terraform code creates all the required AWS services and then uses the published image from ECR to spin up containers

## CI/CD pipeline flow
The gitlab-ci file is writen for gitlab and handles the ci/cd flow. It will create the docker image and then using that image will spin up ecs containers. Here is the flow
1. **Validate:** will do a basic validation of terraform code.
2. **Build docker image:** Next will create the docker image from the provided flask app and register it to AWS ECR. It will only re-create image if any changes made to the docer dir of this repo.
3. **Plan Terraform:** next it would plan terraform.
4. **Apply Terraform:** finally apply the changes to aws. This stage is manual trigger.

## How to use it?

### A. Pre requisits
1. **Gitlab runner:** Setup the gitlab runner and set "privileged = true" for the runner container.
2. **AWS access:** Arrange AWS access for the gitlab runner. Here it uses IAM user with access ID and key. The access ID and key has been added in gitlab ci/cd variables as AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. Can take is approach or use OpenID Connect(recommended) to give the access.
> **_NOTE:_**  If OpenID Connect used, then comment out all of these:
```yml
before_script:
    - *aws_profile
```
3. **Terraform Backend:** This pipeline uses S3 bucket for terraform state file and dynamoDB for state lock.
    - Create the S3 bucket ```my-terraform-remotestate```
    - Create dynamoDB table named ```terraform-state-lock-dynamo```
   
### B. Edit the code
1. **Add account ID:** replace all the ```<account id>``` (total 4) with the account id of target aws account.
2. **Update with required container number:** Change the value of ```desired_count``` to get the desired number of containers. Currently set as 1

### C. Push repo to gitlab
Push the repo to gitlab.

### D. Run the pipeline
The gitlab-ci file is already ready to be used. It should automatically trigger the pipeline when merged.
