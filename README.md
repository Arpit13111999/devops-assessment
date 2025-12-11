# DevOps Assessment - Node.js Todo App

## Project Overview

This is a **Node.js REST API** for managing todos, containerized with Docker, tested with Jest, and set up with a basic CI/CD pipeline.  
The project demonstrates **DevOps & Cloud practices**, including Docker, CI/CD, and infrastructure-as-code (Terraform skeleton included).

---

## Features

- **Health Check Endpoint**
  ```http
  GET /healthz → { "status": "ok", "commit": "<git_sha>" }
Todos API

http
Copy code
GET /api/v1/todos → List all todos
POST /api/v1/todos → Create a todo { id, title, done }
Persistence: In-memory store (DynamoDB placeholder in infra)

Testing: Jest + Supertest

Health check test

Happy path create/list

Negative case (validation)

Observability:

JSON structured logs

Basic request logging

Metrics endpoint ready for Prometheus

Containerization: Multi-stage Dockerfile

Non-root user

Minimal image

.dockerignore included

CI/CD: GitHub Actions

Build & test

ESLint static analysis

npm audit for dependencies

Docker build & scan

Push image to Docker Hub

Architecture (ASCII Diagram)
text
Copy code
                      +-------------------+
                      |   GitHub Repo     |
                      |  (CI/CD Workflow) |
                      +---------+---------+
                                |
                                v
                      +-------------------+
                      |   GitHub Actions  |
                      |  Build / Test /   |
                      |   Docker Scan     |
                      +---------+---------+
                                |
                                v
                      +-------------------+
                      |   Docker Hub      |
                      |  Todo App Image   |
                      +---------+---------+
                                |
                                v
                      +-------------------+
                      |    Local / K8s    |
                      |   Container Run   |
                      +-------------------+
Setup & Run Locally
Clone repo:

bash
Copy code
git clone https://github.com/Arpit13111999/devops-assessment.git
cd devops-assessment
Install dependencies:

bash
Copy code
npm install
Start the server:

bash
Copy code
npm start
Test endpoints:

bash
Copy code
curl http://localhost:3000/healthz
curl -X POST http://localhost:3000/api/v1/todos -H "Content-Type: application/json" -d "{\"title\":\"first\"}"
curl http://localhost:3000/api/v1/todos
Run tests:

bash
Copy code
npm test
Build Docker image:

bash
Copy code
docker build -t arpit19991311/todo-app:latest .
docker run -p 3000:3000 arpit19991311/todo-app:latest
CI/CD
Workflow triggers on push and pull_request to main branch

Stages:

Build & Test (npm test)

ESLint static analysis

Dependency audit (npm audit)

Docker build & scan

Push to Docker Hub (arpit19991311/todo-app:latest)

Scenario / Interview Notes
Incident Response (Suspicious egress from EKS pods)

Isolate affected pods (taint + cordon)

Capture logs, metrics, and pod network traffic

Enable short-term monitoring

Plan 24h incident review & mitigation

Secrets Management

Never commit .env with secrets

Use AWS Secrets Manager / SSM Parameter Store

Implement secret rotation & IAM least privilege

Zero-Trust in K8s

Use IRSA for AWS access per service account

Enforce RBAC for pods & namespaces

Apply NetworkPolicy for segmentation

Optionally use mTLS with service mesh

Supply Chain Security

Pin Docker images to digests

Scan for vulnerabilities (trivy, grype)

Track SBOM for dependencies

Maintain image provenance (SLSA-like)

Cost vs Security Tradeoff

Keep image scans in CI

Use severity gates or allowlists to allow low-risk CVEs

Async scans can run post-deploy for non-critical workloads

Short Questions / Notes

SG vs NACL: SG is stateful, NACL stateless

Terraform state: stores infra state; secure with S3 + DynamoDB lock / local encryption

Container scanning tools: Trivy, Grype

RBAC pod access: Use Role/RoleBinding targeting service account

IRSA: Safer than node role; pods get IAM perms individually

Repo Structure
bash
Copy code
.
├─ src/                 # Node.js code
├─ tests/               # Jest + Supertest
├─ infra/terraform/     # IaC skeleton
├─ k8s/                 # Kubernetes manifests
├─ Dockerfile
├─ .dockerignore
├─ package.json
├─ README.md
└─ .github/workflows/ci.yml
Notes / Future Improvements
Integrate DynamoDB persistence for todos

Add Prometheus / Grafana monitoring

Implement Helm chart for dev/stage/prod

Add OPA/Gatekeeper policies for admission controls

Include SBOM generation & ZAP baseline scans in CI
