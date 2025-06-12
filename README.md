# Infra2App Automation

The project adopts an automation-based approach to provision cloud infrastructure and deploy applications using common DevOps tools. This ensures a consistent and maintainable system through the following stages:
* Containerization: Packaging applications into [Docker containers](https://github.com/LamSut/Play-with-Containers) simplifies deployment across environments.
* Infrastructure Provisioning: AWS resources like EC2, VPC, IAM, S3, DynamoDB, etc. are provisioned with Terraform.
* Configuration Management: Once the infrastructure is ready, Ansible is used to deploy applications remotely.
* CI/CD: GitHub Actions runs the automation pipeline for testing, reviewing and deploying automatically.

![model-detail](https://github.com/user-attachments/assets/5ab2891b-8d32-4f8d-876c-e79743818015)
