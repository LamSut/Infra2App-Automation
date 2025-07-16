# Infra2App Automation
 
The project adopts an automation-based approach to provision cloud infrastructure and deploy applications using common DevOps tools. This ensures a consistent and maintainable system through the following stages:
* Containerization: Packaging applications as [Docker containers](https://github.com/LamSut/ContainYourself) simplifies deployment across environments.
* Blue-Green Deployment: Updates are released with minimal downtime using parallel environments.
* Infrastructure Provisioning: Terraform is used to provision AWS infrastructure components.
* Configuration Management: After provisioning, Ansible is used to deploy applications remotely.
* CI/CD: GitHub Actions manages the CI/CD pipeline for automated build, test and deployment workflows.

<img width="952" height="952" alt="Detail" src="https://github.com/user-attachments/assets/e9d966f4-59db-4069-849c-cf4502785194" />
