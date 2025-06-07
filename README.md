# IaaS Automation

The project uses an automation-based approach to manage cloud infrastructure with common DevOps tools.  
This approach helps maintain a consistent and manageable system by following these main steps:
* Containerization: Packaging applications into Docker containers enables easy deployment and management across environments.
* Infrastructure Provisioning: AWS resources like EC2, VPC, IAM, S3, DynamoDB, etc. are created using Terraform.
* Configuration Management: After the infrastructure is ready, Ansible is used to set up applications.
* CI/CD: GitHub Actions runs the automation pipeline for testing, reviewing and deploying automatically.

---
![model-detail](https://github.com/user-attachments/assets/8a4e30d0-a9f4-4853-bd65-efa954c776f9)
