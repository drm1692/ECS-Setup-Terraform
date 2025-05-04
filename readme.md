# 🚀 Prefect ECS Fargate Deployment with Terraform

This project provisions an **AWS ECS Fargate infrastructure** to run **Prefect workers** using **Terraform**.

---

## 📌 Purpose

Automate the deployment of Prefect workers using Infrastructure as Code on AWS.

---

## 🛠️ Infrastructure as Code (IaC) Tool

- **Tool Used:** Terraform

### 🔍 Rationale

- Declarative configuration for reproducible infrastructure
- Modular design for reusability and scalability
- Strong community support and robust AWS provider features

---

## ✅ Prerequisites

Before deployment, ensure you have:

- AWS CLI configured with appropriate credentials
- Terraform installed (v1.0 or later)
- A Prefect Cloud account with a workspace
- A Prefect API key stored in AWS Secrets Manager as a **JSON key-value pair**

---

## 🚀 Deployment Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
``` 

### 2. Configure Terraform Variables

Edit the terraform.tfvars file to set your configuration variables.


### 3. Initialize Terraform
```bash
terraform init
``` 

### 4. Review the Execution Plan
```bash
terraform plan
``` 

### 5. Apply the Configuration
```bash
terraform apply
```

--- 

## 🔎 Verification steps

  - Ensure the ECS service is running and the task is in a RUNNING state.
  - Use CloudWatch Logs to verify that the Prefect worker has started successfully.

---

## 🧹 Resource Cleanup

To destroy all resources created by this Terraform configuration:

```bash
terraform apply
```