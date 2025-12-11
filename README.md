 Architecture Overview

Below is a simple ASCII diagram representing the architecture of this project:
 
                         ┌────────────────────────┐
                         │      GitHub Repo       │
                         │  (Code + Terraform +   │
                         │   K8s Manifests + CI)  │
                         └───────────┬────────────┘
                                     │
                              GitHub Actions
                              (CI/CD Pipeline)
                                     │
                                     ▼
                          ┌────────────────────┐
                          │     AWS EKS        │
                          │  (Kubernetes Cluster)
                          └───────┬────────────┘
                                  │
                 ┌────────────────┼─────────────────┐
                 │                │                 │
                 ▼                ▼                 ▼
       ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
       │ Deployment     │ │  Service       │ │ NetworkPolicy  │
       │ (Pods running  │ │ (LB / NodePort │ │ (Restrict Pod  │
       │  application)  │ │  access)       │ │  communication)│
       └────────────────┘ └────────────────┘ └────────────────┘



Repository Structure:


devops-assessment/
│
├── infra/
│   └── terraform/
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── versions.tf
│
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── networkpolicy.yaml
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── src/
│   └── app.py  (or your app code)
│
└── README.md
