# Secured-remote-eks-access
This repository contains the write up for Shaliya's DevOps Engineering Fellowship project at Insight Data Science.

## Table of Contents

1. [Introduction](README.md#introduction)
2. [Features](README.md#Features)
3. [System Diagram](README.md#background)
4. [Usage](README.md#usage)
	* Setting up AWS EKS
	* Setting up Okta
5. [Outcomes](README.md#outcomes)
	* Demo
	* Demo
6. [Conclusion](README.md#conclusion)

## Introduction

The goal of this project is to implement an Identity and Access Management system using Okta as the Identity provider on Amazon Web Services (AWS) to provide a secure access to users in an organization and provide remote access to developers to securely connect to EKS clusters.

## Features

There are two modules, EKS and Okta, that are integrated to implement the system. The EKS module deploys an EKS cluster on AWS and is built using the repository [learn-terraform-provision-eks-cluster](https://learn.hashicorp.com/tutorials/terraform/eks). The Okta module uses the [terraform-okta-aws](https://github.com/elastic/terraform-okta-aws/) for setting up/connecting AWS account(s) with an Okta AWS app.

Okta's integration with Amazon Web Services (AWS) allows end users to authenticate to one or more AWS accounts and gain access to specific roles using single sign-on with SAML. 
For a detailed explanation of Okta SSO setup with AWS, see the [Okta SAML 2.0 AWS Guide](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service).

After completing the setup, AWS roles can be assumed from Okta.

**NOTE**: This module uses Terraform 12 syntax.

## System Diagram
![Fig 1: system diagram](https://github.com/ShaliyaJ/Secured-remote-eks-access/blob/main/IAM%20(1).png)

## Usage

### Setting up AWS EKS

To use this project you will need:

* a configured AWS CLI
* AWS IAM Authenticator
* kubectl
* wget (required for the eks module)

You will need to configure your AWS credentials before using this project:


#### Linux
Add the following in your `~/.bashrc` or `~/.zshrc` with your credentials:
```
export AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
```
### Setting up Okta
This example setups an AWS account for login via Okta, using both Okta modules [master](../../modules/master) and [child](../../modules/child) in one account. It creates two roles which can be assumed via Okta. 

To run the example:
1) Create an AWS app in Okta.
2) Download the metadata into the file `metadata.xml` loacted in Okta/main folder
3) Run the following commands by making sure you are in the main folder in Okta (Don't forget to set AWS credentials for Terraform)
```
cd Okta/main
terraform init
terraform apply
terraform output
```
4) The 'terraform output' command generates the file `output_example.json`. You should see the following section in the outputs:

```json
{
  "okta_user": {
    "sensitive": false,
      "type": "string",
      "value": "arn:aws:iam::XXXXX:user/okta-app-user"
  }
}
```
5) Login to your AWS account and generate an access and secret key for the user created above.
6) Use the credentials to configure the AWS Okta app. See the [Okta App Configuration](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step4) docs.
7) Remember to update the IDP Arn in Okta app:
![Fig 2: okta arn]("https://github.com/ShaliyaJ/Secured-remote-eks-access/blob/main/okta_config_arn.png)

8) You should also see the following in the outputs section:

```json
{
  "sso_role_arns": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string",
        "string"
      ]
    ],
    "value": [
      "arn:aws:iam::XXXXX:role/DemoOktaEC2ReadOnly",
      "arn:aws:iam::XXXXX:role/DemoOktaAdmin"
    ]
  }
}
```
Once you have mapped users to these roles via the Okta, they can assume these two role into AWS!


## Testing the Project

```
cd ../../EKS
terraform init
terraform apply
```










