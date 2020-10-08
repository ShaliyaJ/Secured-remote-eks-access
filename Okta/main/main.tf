terraform {
  required_version = "~> 0.12.20"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
}

module "okta_master_setup" {
  source    = "../modules/master"
  user_name = "OktaSSOUser"
}

module "okta_child_setup" {
  source                 = "../modules/child"
  idp_name               = "okta"
  idp_metadata           = file(var.idp_metadata_file)
  master_accounts        = list(module.okta_master_setup.okta_master_account_id)
  add_cross_account_role = false
}

// create a role that is assumable by Okta
resource "aws_iam_role" "sso_role_ec2" {
  name               = "testrole"
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    ${module.okta_child_setup.okta_assume_role_statement}
  ]
}
JSON
}

resource "aws_iam_role_policy" "sso_role_ec2_policy" {
  name   = "DemoOktaEC2ReadOnlyPolicy"
  role   = aws_iam_role.sso_role_ec2.name
  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}

// create another role that is assumable by Okta
resource "aws_iam_role" "sso_role_admin" {
  name               = "EKS-DEV-developer"
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    ${module.okta_child_setup.okta_assume_role_statement}
  ]
}
JSON
}
resource "aws_iam_role_policy" "sso_role_admin_policy" {
  name   = "OKTA-EKS-Assume-Role"
  role   = aws_iam_role.sso_role_admin.name
  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:GetPolicy",
                "iam:ListAttachedRolePolicies",
                "eks:DescribeCluster",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy",
                "eks:*"
                ],
      "Resource": "*"
    }
  ]
}
JSON
}