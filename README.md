# Secured-remote-eks-access
This repository contains the write up for Shaliya's DevOps Engineering Fellowship project at Insight Data Science.

## Table of Contents

1. [Introduction](README.md#introduction)
2. [Features](README.md#Features)
3. [System Diagram](README.md#background)
4. [DevOps Problem](README.md#devops-problem)
	* Overview
	* Approach
	* Challenges
	* Immutable Configuration
	* Interaction between Terraform, Okta and EKS clusters
5. [Outcomes](README.md#outcomes)
	* Demo
	* Demo
6. [Conclusion](README.md#conclusion)

## Introduction

The goal of this project is to implement an Identity and Access Management system using Okta as the Identity provider on Amazon Web Services (AWS) to provide a secure access to users in an organization and provide remote access to developers to securely connect to EKS clusters.

## Features

There are two modules-EKS and Okta that are integrated to implement the system. The EKS module deploys EKS cluster on AWS and is built using the repository [learn-terraform-provision-eks-cluster](https://learn.hashicorp.com/tutorials/terraform/eks).The Okta module uses the [terraform-okta-aws](https://github.com/elastic/terraform-okta-aws/) for setting up/connecting AWS account(s) with an Okta AWS app.

Okta's integration with Amazon Web Services (AWS) allows end users to authenticate to one or more AWS accounts and gain access to specific roles using single sign-on with SAML. 
For a detailed explanation of Okta SSO setup with AWS, see the [Okta SAML 2.0 AWS Guide](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service).

After completing the setup, AWS roles can be assumed from Okta

**NOTE**: This module uses Terraform 12 syntax.

## System Diagram




