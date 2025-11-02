# Automated Air-Gapped Kubernetes Infrastructure on AWS  
**Repository:** [OlegBray/D-B_project](https://github.com/OlegBray/D-B_project)

## 📘 Overview  
This project demonstrates a **complete DevOps infrastructure automation** workflow on **AWS**, built using **Terraform** for infrastructure provisioning and **Ansible** for configuration management and deployment.  

The goal was to deploy a fully functional **RKE2 Kubernetes cluster** in an **air-gapped environment** — completely isolated from the public internet — while maintaining full operational capability.

### Key Highlights  
- **Infrastructure as Code (IaC):** Provisioned AWS resources — VPC, EC2 instances, IAM roles, and networking — using Terraform.  
- **Automated Deployment:** Used Ansible to configure and deploy a 4-node setup:  
  - 1 × **Bastion host**  
  - 3 × **RKE2 nodes** (1 master, 2 workers)  
- **Air-Gapped Environment:**  
  - No outbound internet access for cluster nodes.  
  - Private **Docker Registry** for hosting required images.  
  - Manual packaging and transfer of **APT**, **Docker**, and **TAR** dependencies into the isolated network.  
  - Full deployment handled via Ansible, ensuring offline functionality.  
- **Application Deployment:** Installed **NGINX** on the Kubernetes cluster using **Helm**, with **port forwarding** configured for controlled external access.

---

## 🧰 Technologies Used  
- **Terraform** – AWS provisioning (VPC, EC2, IAM, networking)  
- **Ansible** – Automated configuration and deployment  
- **RKE2** – Lightweight Kubernetes distribution  
- **Docker & Private Registry** – Offline image management  
- **Helm** – Application deployment on Kubernetes  
- **AWS** – Cloud infrastructure (VPC, EC2, Security Groups, IAM)  

---

## 🏗️ Architecture Overview  
```text
AWS VPC
└── Bastion Host (EC2)
    └── SSH / Private Network Access → RKE2 Cluster (1 Master + 2 Nodes)
        ├── Private Docker Registry
        ├── No Internet Egress (Air-Gapped)
        └── Helm → NGINX Pod(s)
            └── Port-Forwarding → Local Machine
```
## ⚙️ Deployment Steps  

1. **Infrastructure Setup (Terraform)**  
   - Edit `terraform.tfvars` or `variables.tf` with your AWS configuration (region, key pair, CIDR ranges, etc.).  
   - Run:  
     ```bash
     terraform init
     terraform plan
     terraform apply
     ```
   - Terraform will provision all required AWS resources.

2. **Access Bastion Host**  
   - Connect via SSH to the Bastion EC2 instance created by Terraform.  

3. **Offline Package Preparation**  
   - Download and package required **Docker images**, **APT**, and **TAR** files on a connected machine.  
   - Transfer these files manually to the Bastion or directly to the nodes.  
   - Set up a **private Docker registry** inside the cluster.  

4. **Cluster Configuration (Ansible)**  
   - Run the Ansible playbooks to:  
     - Install **RKE2** on all nodes.  
     - Configure the **private Docker registry**.  
     - Deploy **Helm** and install **NGINX**.  

5. **Port Forwarding (Optional)**  
   - From your local machine, use port forwarding to access NGINX running in the isolated cluster.

---

## 💡 Challenges & Solutions  

**Challenge:** Operating a Kubernetes cluster without any internet access.  
**Solution:**  
- Built an offline deployment strategy using a **local Docker registry**.  
- Pre-packaged all required container images and system dependencies.  
- Automated the transfer and deployment process via **Ansible playbooks**.  
- Ensured full cluster functionality without external network dependency.

---

## 📈 Lessons Learned  
- Integrating **Terraform** and **Ansible** for seamless end-to-end automation.  
- Managing **air-gapped deployments** securely and efficiently.  
- Building and maintaining a **private container registry**.  
- Deploying **Helm charts** on RKE2 clusters in isolated environments.  
- Understanding Kubernetes networking, security groups, and Bastion configurations.
