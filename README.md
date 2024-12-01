# Secure File Scan Infrastructure

## Overview

This project provides Terraform scripts to deploy a secure web application on AWS. The scripts configure essential components such as a Virtual Private Cloud (VPC), subnets, security groups, and an EC2 instance, ensuring a robust and scalable infrastructure for hosting the web application.

## Getting Started

To deploy the web application infrastructure on AWS, follow these steps:

1. **Prerequisites:**
   - Install Terraform on your local machine. You can download it from [terraform.io](https://www.terraform.io/downloads.html).
   - Configure your AWS credentials. You can set them up using environment variables, AWS shared credentials file, or IAM roles.

2. **Clone the Repository:**

    ```bash
    git clone https://github.com/0xZainRaza/Cloud-Web-App
    cd Cloud-Web-App
    ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```
4. **Review and Customize Configuration:**
   - Review the `main.tf` file to understand the infrastructure components being deployed.
     
5. **Deploy the Infrastructure:**

   ```bash
   terraform apply
   ```
6. **Access the Web Application:**
   - Once the deployment is complete, you will receive the public IP address of the EC2 instance.
   - Access your web application by navigating to the provided IP address in your web browser.

## Cleanup

To avoid incurring unnecessary costs, don't forget to destroy the resources when they are no longer needed:
   ```bash
   terraform destroy
   ```
