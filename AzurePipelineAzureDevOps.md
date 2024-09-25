# Azure Pipeline with Azure DevOps

1. [Disclaimer](#disclaimer)
1. [Introduction](#introduction)
1. [Prerequisites](#prerequisites)
1. [Step 1 -> Project](#step-1-->-Project)
1. [Step 2 -> Repository](#step-2-->-Repository)
1. [Step 3 -> Planning + pre-creation of resources](#step-3-->-Planning-+-pre-creation-of-resources)
1. [Step 4 -> Azure Devops connection to Azure resources](#step-4-->-Azure-Devops-connection-to-Azure-resources)
1. [Step 5 -> Azure DEvOps pipeline](#step-5-->-Azure-DevOps-pipeline)
1. [Step 6 -> Azure Web App](#step-6-->-Azure-Web-App)


## Disclaimer

This post do not describe detail process (with screenshots) behind pipeline creation but rather overall approach to the Azure Pipeline with Azure DevOps Service. The reason for this is Azure itself constantly do some changes with GUI to improve flow for the cloud operator. After a while screenshots could be obsolete. The core concept stays the same and I what to focus on them and on official Microsoft documentation.

## Introduction

Azure allows us to create paid or free resources. These resources are a reflection of the entire infrastructure necessary for the application to function properly. So, sometimes these resources are paid, sometimes we pay if we use them, and sometimes we pay if we create them (visit the Azure pricing calculator <https://azure.microsoft.com/en-us/pricing/calculator/> because these are the details that matter). These resources represent all the infrastructure with many options for customizing settings and security.

PS. We could automate creation of those resources by terraform itself. Official HashiCorp provider is called "azurerm" and can be found at <https://registry.terraform.io/providers/hashicorp/azurerm>

## Prerequisites

1. Active Azure account,
2. Access to Azure DevOps Service.

## Step 1 -> Project

To start with the flow, we need to have something to base all our work on. Azure DevOps "Project" is where we create new repositories, review boards, sprints, create pipelines and test plans, collaborate, document and more (here reference for Artifacts). Creation process is described in Microsoft documentation at <https://learn.microsoft.com/en-us/azure/devops/organizations/projects/create-project>. Please notice that in documentation we got also "Prerequisites" part. So we must already have "Organization" set up as described.

## Step 2 -> Repository

Now we may add repository for our application code. For that we utilize Azure Repos (unlimited, cloud-hosted private Git repos). It is default option when we create repository. Process for creation is described at <https://learn.microsoft.com/en-us/azure/devops/repos/git/create-new-repo>.

As an example application I chose one of the free example projects provided by Microsoft OpenSource Community from <https://github.com/microsoft/devops-project-samples/tree/master/node/plain/container/Application>. After some debugging in "Step 6 -> Azure Web App" I changed few lines in ```server.js``` file. Thanks to this, the CI/CD process involving the container worked correctly (it's a test environment, so there was no need to ask the developer :)) The contents of the file after the changes are presented below.

```js
'use strict';
var http = require('http');
const port = process.env.port || 80;
var fs = require('fs');

http.createServer(function (req, res) {

    fs.readFile('index.html', function (err, data) {
        res.writeHead(200, { 'Content-Type': 'text/html', 'Content-Length': data.length });
        res.write(data);
        res.end();
    });
}).listen(port);
```

## Step 3 -> Planning + pre-creation of resources

1. We start by creating a resource group in the Azure Portal (sample name “test-2-azure-rg”). From now on treat it as a container for all other resources.
2. After reading the file README.md, from example application we can notice that app could be deployed as a Azure Web App. It also contains Dockerfile that we could use for Azure Container Registry (ACR).
3. I want to deploy the application to Azure Web App. The service will use a container from ACR that will be created via Azure DevOps pipeline using an Azure VM with the deployment agent installed and listening for a job.
   1. Inside resource group create "Container Registry" (example name "test2azureacr", Pricing = Basic)
   2. Inside resource group create "Virtual Machine" (example name "test2azvm", Availability options = No infrastructure redundancy required, Image = Ubuntu, Size = B1s (after creation Resize Option is also available))
      1. On the VM we can change the network settings to only allow SSH traffic from our own IP address (changing the port rule is a good idea)
      2. SSH to VM and install
         1. "vsts-agent-linux" == full instruction is available from Azure DevOps "Project Settings" when we go to "Agent Pool" and select "Create new pool". From there add a "New agent" (the entire instruction will be displayed on the screen).
         2. Docker ==  full instruction at official Docker documentation at <https://docs.docker.com/engine/install/ubuntu/>. Please go also with Linux post-installation steps for Docker Engine <https://docs.docker.com/engine/install/linux-postinstall/>. It's mainly about adding our user on which the agent is running to the docker group.

## Step 4 -> Azure Devops connection to Azure resources

### Before we start with pipeline we must convince our resource group from Azure Portal to trust our Azure DevOps Service. For that, from Azure Portal we could use "User Assigned Managed Identity" resource.

1. After creation of "User Assigned Managed Identity" (example name "test-2-azure-uami") we go to that resource and under "Settings" we select "Federated credentials" and "Add Credential"
1. For Azure Container Registry select "Other" for "Federated credential scenario" and set other required values:
   1. Issuer URL == one place to check it, is to go to Azure DevOps and under "Organization Settings -> Microsoft Entra" download Azure DevOps organizations connected to our directory. The correct issuer URL starts with ```https://vstoken.dev.azure.com``` and after that we put Organization Id from file we downloaded ```https://vstoken.dev.azure.com/<Organization Id>```
   2. Subject identifier == Standard form is ```sc://<Organization Name>/<Project Name>/<any connection name>```. We create the connection name at this stage (example name "acr_test_service_conn")
   3. Credential details Name = We resource create it at this stage and it must match what we will enter to  Azure DevOps (example name "acr-managed-identity-test"). This is also used as "dockerRegistryServiceConnection" variable name in our future pipeline "azure-pipelines.yml".
1. For Azure VM select "Other" for "Federated credential scenario" and set other required values:
   1. Issuer URL == the same as for ACR
   1. Subject identifier == similar to ACR setting. Example name "vm_test_service_conn"
   1. Credential details Name == similar to ACR setting. Example name "vm-managed-identity-test"
1. In "User Assigned Managed Identity", select "Azure role assignments" and add two new roles for "AcrPush" and "AcrPull" (Scope = Resource group for both)
1. On Azure VM select "Identity" and "User assigned" tab. Select previously set "User Assigned Managed Identity" with example name "test-2-azure-uami". After it is done associated resource should appear on "Associated resources" tab in our "User Assigned Managed Identity"

### After all set up, in "Project Settings" on Azure DevOps we look for "Service connections"

1. Create new connection for docker registry
   1. From the panel, look for "Azure Container Registry" and select "Authentication Type" as "Managed Service Identity"
   1. Provide any necessary values. "Service connection name" is one that we created earlier(acr-managed-identity-test). Checkout "Grant access permission to all pipelines"

1. Create new connection for VM
   1. From the panel, look for "Azure Resource Manager" and "Managed identity"
   2. Provide any necessary values. "Service connection name" is one that we created earlier(vm-managed-identity-test). Checkout "Grant access permission to all pipelines"

## Step 5 -> Azure DevOps pipeline

Example pipeline to build and push to Azure Container Registry could look like below. We create "azure-pipelines.yml" file in our repository and put the necessary content there. Our example is mostly self explanatory but many options can be found in Microsoft documentation (for example at <https://learn.microsoft.com/en-us/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml>). Please notice a special tags for different kind of jobs. For "Build and publish image to Azure Container Registry" we used "task: Docker@2" described at <https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/docker-v2?view=azure-pipelines&tabs=yaml>. There are many pre-configured tasks and many possibilities with lots of options.

```yml
trigger:
- master

variables:
  dockerRegistryServiceConnection: 'acr-managed-identity-test'
  imageRepository: 'devoptest'
  dockerfilePath: '$(Build.SourcesDirectory)/Dockerfile'
  tag: '$(Build.BuildId)'

stages:
- stage: Build
  displayName: Build and publish stage
  jobs:
  - job: Build
    displayName: Build job
    pool:
      name: 'VMpool'

    steps:
    - task: Docker@2
      displayName: Build and publish image to Azure Container Registry
      inputs:
        command: buildAndPush
        containerRegistry: $(dockerRegistryServiceConnection)
        repository: $(imageRepository)
        dockerfile: $(dockerfilePath)
        tags: |
          $(tag),latest

```

## Step 6 -> Azure Web App

1. Once the build is complete, we can check our container registry to see if we have a new ACR repository available
1. In the resource group we can now create an Azure Web App (example name "test-2-azure-app") and select the publish method from the newly created ACR
1. In the "Deployment Center" in "Azure Web App" we set all the necessary values. We can use the "Continuous deployment" option to automatically publish our application when a new docker image appears in ACR.
1. Remember to use debugging options if needed
   1. With "Azure Web App" we should enable "App Service logs" under "Monitoring" for more information from container
   1. Logs will appear in "Log stream" tab under "Monitoring".
