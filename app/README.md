## 3-Tier Full Stack Application with Docker, NGINX & Kubernetes

## Architecture

Client (Browser)
       ↓
   Ingress (myapp.local)
       ↓
   NGINX (Reverse Proxy)
       ↓
 ┌───────────────┬───────────────┐
 │               │               │
Frontend      Backend        MongoDB
(React)      (Node API)      (Database)

## Tech Stack
React.js
Node.js + Express
MongoDB
NGINX
Docker & Docker Compose
Kubernetes (Minikube)

## Features
Docker Setup
Multi-container architecture using Docker Compose
Inter-container communication via Docker network
Environment variable management using .env
Secure .env handling via .gitignore

## Kubernetes Deployment
Migrated from Docker Compose → Kubernetes
Created modular K8s manifests:
Deployments
Services (ClusterIP & NodePort)
Ingress (NGINX Controller)
Implemented:
Horizontal Pod Autoscaler (HPA - CPU 70%)
NGINX as reverse proxy inside cluster
Custom domain routing (myapp.local)


## Project Structure

project-root/
│
├── frontend/
├── backend/
├── nginx/
├── docker-compose.yml
│
└── k8s/
    ├── frontend/
    ├── backend/
    ├── mongo/
    ├── nginx/
    ├── ingress/
    └── hpa/


## Getting Started

1. Clone Repository
    git clone <your-repo-url>
    cd project-folder

2. Setup Environment Variables

    Create a .env file:

    PORT=5000
    MONGO_URI=your_mongo_connection_string

## Run with Docker
    docker-compose up --build

## Access
    Frontend → http://localhost:8081
    API → http://localhost:8081/api/users


Run on Kubernetes (Minikube)

1. Start Minikube
    minikube start

2. Enable Ingress
    minikube addons enable ingress

3. Deploy Application
    kubectl apply -f k8s/

4. Start Tunnel (Important for Windows)
    minikube tunnel

## Kubernetes Components
Frontend Deployment + Service
Backend Deployment + Service
MongoDB Deployment + Service
NGINX Deployment + NodePort Service
Ingress Controller (NGINX)
HPA (Auto Scaling based on CPU)


## Real-World Debugging & Learnings
Fixed NGINX reverse proxy path issue (/api stripping bug)
Debugged ConfigMap mounting issue
Resolved Service ↔ Pod label mismatch (Endpoints issue)
Troubleshot Ingress routing & DNS resolution
Understood Minikube networking (Windows + Docker driver)


## Security Best Practices
.env excluded via .gitignore
.env.example added
No secrets committed to GitHub


## Future Improvements
Add JWT Authentication
Deploy on AWS (EKS / EC2)
CI/CD Pipeline (GitHub Actions + DockerHub + ArgoCD)
Logging & Monitoring (Prometheus + Grafana)

## Key Takeaways
Hands-on experience with containerization → orchestration transition
Deep understanding of Kubernetes networking & debugging
Built a production-style scalable architecture

