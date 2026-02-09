# Production-Ready CI/CD Pipeline with Zero-Downtime & Rollback

## Overview

This project demonstrates a real-world CI/CD pipeline for deploying a containerized application on AWS using DevOps best practices. The pipeline supports automated builds, zero-downtime deployments, and instant rollback using immutable Docker images.

## Architecture

GitHub Actions → Docker → AWS ECR → EC2 (Linux) → Nginx → Application

## Features

- Automated CI/CD using GitHub Actions
- Dockerized application following best practices
- Immutable Docker images stored in AWS ECR
- Secure AWS authentication using IAM roles
- Zero-downtime Blue-Green deployments
- Nginx reverse proxy for traffic routing
- Version-based rollback strategy

## CI/CD Flow

1. Code is pushed to the `main` branch
2. GitHub Actions builds a Docker image
3. Image is tagged with a version and `latest`
4. Image is pushed to AWS ECR
5. EC2 pulls the image using IAM role authentication
6. Blue-Green deployment is executed
7. Nginx switches traffic without downtime

## Rollback Strategy

Each pipeline run produces a versioned Docker image.

If a deployment causes issues, rollback is performed by redeploying a previous image version using the same deployment script.

### Example rollback command

```bash
./deploy.sh <ECR_REPO>:41
```
