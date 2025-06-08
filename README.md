# 🛠️ DevOps Production Deployment with AWS (ECS Fargate + Terraform + GitHub Actions)

This project demonstrates a full-fledged **CI/CD pipeline and infrastructure setup** for deploying a containerized application on AWS using:

- **Docker** for containerization
- **GitHub Actions** for CI/CD
- **Amazon ECR** for container registry
- **Amazon ECS Fargate** for container orchestration
- **ALB (Application Load Balancer)** for traffic routing
- **Terraform** for infrastructure as code
- **CloudWatch** for monitoring and alerting

---

## 🐳 1. Dockerization

Both frontend and backend apps are containerized.

**Example Dockerfile** (`./frontend/Dockerfile`)
```Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

**Backend** runs on port `8000`.

---

## ⚙️ 2. CI/CD with GitHub Actions

**`.github/workflows/deploy.yml`** automates:

- Docker image build for frontend & backend
- Pushing to AWS ECR

```yaml
on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-south-1

      - name: Log in to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build & Push Backend to ECR
        run: |
          docker build -t backend ./backend
          docker tag backend:latest ${{ secrets.ECR_BACKEND_REPO }}:latest
          docker push ${{ secrets.ECR_BACKEND_REPO }}:latest

      - name: Build & Push Frontend to ECR
        run: |
          docker build -t frontend ./frontend
          docker tag frontend:latest ${{ secrets.ECR_FRONTEND_REPO }}:latest
          docker push ${{ secrets.ECR_FRONTEND_REPO }}:latest
```

---

## ☁️ 3. Terraform Architecture

### 🔹 VPC Module
- Public subnets in two AZs
- Internet Gateway & Route Tables

### 🔹 ECS Module
- ECS Cluster
- Task Definitions for frontend and backend
- Services attached to ALB
- Fargate launch type

### 🔹 IAM
- Execution role with least-privilege

### 🔹 ALB
- Listener + target groups (frontend & backend)
- Health checks enabled

### 🔹 Monitoring
- CloudWatch log groups for each task
- CPU & Memory alarms with SNS email alerts

---

## ⚙️ 4. Runtime Configuration

The following variables are prompted at runtime or passed via `terraform.tfvars`:

```hcl
variable "alert_email"
variable "cpu_threshold"   # e.g., 75
variable "memory_threshold" # e.g., 75
```

---

## ✅ 5. Health Checks

- ALB health checks monitor task endpoints
- Tasks marked unhealthy are replaced automatically

---

## 📦 Cleanup

To destroy the entire infrastructure:
```bash
terraform destroy
```

---

## 🧪 Testing the Setup

- Visit ALB DNS to confirm frontend loads
- API path `/api/*` should route to backend
- Trigger high CPU to test alarm mail

---

## ✉️ Email Alerts

- SNS configured to send email when alarms trigger
- Email address is passed during deployment

---

## 📌 Author

**Pradeep Bisht**
Email: `pradeepbishtusar@gmail.com`
Region: `ap-south-1 (Mumbai)`
