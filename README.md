# IaaS Automation

The project uses an automation-based approach to manage cloud infrastructure with common DevOps tools.  
This approach helps maintain a consistent and manageable system by following these main steps:
* Containerization: Packaging applications into [Docker containers](https://github.com/LamSut/Play-with-Containers) simplifies deployment across environments.
* Infrastructure Provisioning: AWS resources like EC2, VPC, IAM, S3, DynamoDB, etc. are created using Terraform.
* Configuration Management: After the infrastructure is ready, Ansible is used to set up applications.
* CI/CD: GitHub Actions runs the automation pipeline for testing, reviewing and deploying automatically.

![model-detail](https://github.com/user-attachments/assets/5ab2891b-8d32-4f8d-876c-e79743818015)
