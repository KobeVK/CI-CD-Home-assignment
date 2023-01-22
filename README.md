# Versatile
DevOps Engineer Home Challenge for @Versatile

- [Project purpose and architecture](#architecture)
- [Technologies used](#actions)
- [Deployment ](#projects)
- [The tests ](#tests)
- [How to use](#scopes)
- [Future](#scopes)


# Project purpose
DevOps Engineer Home Challenge for @Versatile
As part of this Home assignment, I was required to create a web-app that returns Hello,<name> , deploy it automatically, test and create useful CI flow.

important notes:
1. Engineers cannot deploy to same enviorment <br>
This was done by using GIT to manage my Terraform code. It allows me to track changes to your code and manage conflicts one build at a time.
2. Links can be seen throughout the Jenkins jobs run <br>
2.1 deployed web app<br>
2.2 docker image<br>
3. Emails on failed test<br>



# Architecture
![Versatile web app CI diagram](docs/versatile_ci_flow.png)

<br>
Versatile web app  CICD flow involves the following stages: <br><br>

1. `Deploy` <br>
In this stage, we deploy an EC2 instance to aws, using terraform aws module<br>
2. `verify`<br>
In this stage, we verify that the EC2 instance was created succesfully 
3. `Install` <br>
In this stage, we install our web application on top of the EC2 using ansible whcih runs docker-compose to initiate a docker container that holds our web app <br>
4. `Test` <br>
In this stage, we test the functionality of the web-app <br>
such as: <br>
    4.1 Health Checks
    4.2 Health Checks
    4.3 Health Checks
5. `Release` <br>
In this stage, we release the image as artifact to dockerhub. <br>
This image containes the latest of our code
6. `Destroy`<br>
On development branches only (pipelines that came from any other branch but `main`)
the pipeline will kill the EC2 machine that was created after 10 minuets

as for production, the 

# Deployment
To deploy development enviornemt:
1. login to jenkins in http://13.38.117.100:8080/job/versatile-app-build-test-deploy/
2. go to versatile-app-build-test-deploy job
3. press on your development branch
4. build 




# The tests

# How to use

# Artifacts
Automatic versioning in the pipeline

# Future work
1. enable terraform variables to choose from a drop down list, just to not always use the free tier
2. make production web-app always on and re-deploy with flag
3. fix folder structure to better visibility (ansible files, TF files, Docker files)
4. add proxy such as NginX




