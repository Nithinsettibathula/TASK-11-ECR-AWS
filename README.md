# TASK-11-ECR-AWS

This repository contains the components for an example CI/CD pipeline that builds a Docker image, pushes it to Amazon ECR, and deploys it to ECS using Fargate.

## Structure

```
TASK-11-ECR-AWS/
├── .github/                 # GitHub Actions workflows
│   └── workflows/
│       └── deploy.yml       # CI/CD pipeline definition
├── app/                    # Module 1: Application Code
│   ├── src/                # Source code for the sample Node.js app
│   ├── package.json        # Dependencies
│   └── Dockerfile          # Builds the container image
├── ecs-configs/            # Deployment configs (taskdef/appspec)
├── terraform/              # Module 3: Infrastructure as Code
│   ├── main.tf             # Root that calls modules
│   ├── variables.tf        # Input variables for terraform
│   ├── outputs.tf          # Outputs from root
│   └── modules/            # Modular subdirectories
│       ├── ecr/            # Creates nithin-task-11-ecr
│       ├── ecs/            # Creates ECS cluster & service
│       └── codedeploy/     # CodeDeploy app/group
└── README.md               # This documentation
```

## Usage

1. **Terraform**
   - Initialize: `terraform init`
   - Apply: `terraform apply` (creates ECR repository and ECS cluster)

2. **Build and deploy**
   - Push code to `main` branch with the necessary GitHub secrets set:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - Optional environment variables for ECR registry/repository
   - GitHub Actions will build the Docker image, push to ECR, and (optionally) update ECS.

3. **Local testing**
   - Inside `app/`, run `npm install && npm start` to start the sample server.
