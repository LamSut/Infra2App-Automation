# Infra2App Automation
 
This implementation project automates AWS infrastructure provisioning and application deployment using common DevOps tools.  
The process ensures a consistent and maintainable system through the following stages:  
* Containerization: Packaging applications as [Docker containers](https://github.com/LamSut/ContainYourself) simplifies deployment across environments.
* Blue-Green Deployment: Updates are released with minimal downtime using parallel environments.
* Infrastructure Provisioning: Terraform is used to provision AWS infrastructure components.
* Configuration Management: After provisioning, Ansible is used to deploy applications remotely.
* CI/CD: GitHub Actions manages the CI/CD pipeline for automated build, test and deployment workflows.

<img width="953" height="953" alt="Detail" src="https://github.com/user-attachments/assets/415884b7-7157-4be6-9b6b-90f73f9968d3" />
