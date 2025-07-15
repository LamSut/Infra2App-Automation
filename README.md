# Infra2App Automation
 
The project adopts an automation-based approach to provision cloud infrastructure and deploy applications using common DevOps tools. This ensures a consistent and maintainable system through the following stages:
* Containerization: Packaging applications as [Docker containers](https://github.com/LamSut/ContainYourself) simplifies deployment across environments.
* Blue-Green Deployment: Updates are released with minimal downtime using parallel environments.
* Infrastructure Provisioning: Terraform is used to provision AWS infrastructure components.
* Configuration Management: After provisioning, Ansible is used to deploy applications remotely.
* CI/CD: GitHub Actions manages the CI/CD pipeline for automated build, test and deployment workflows.

<img width="812" height="832" alt="Detail" src="https://github.com/user-attachments/assets/b45faa4a-635b-480d-86a7-d8c4547a984a" />
