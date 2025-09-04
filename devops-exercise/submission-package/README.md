# DevOps Exercise Repository

This repository contains the deliverables for my DevOps Intern take-home exercise.

## Contents

- `disk_monitor.sh` - Bash script for monitoring disk usage
- `app.py` - Sample Flask web application
- `Dockerfile` - Container configuration for the web app
- `docker-compose.yml` - Multi-service orchestration
- `.github/workflows/` - CI/CD pipeline configuration
- `docs/` - Documentation and troubleshooting guides

## Getting Started

### Prerequisites
- Python 3.9+
- Docker & Docker Compose
- Git

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Access the application
open http://localhost:5000
```

### Docker Usage
```bash
# Build the image
docker build -t devops-exercise .

# Run the container
docker run -p 5000:5000 devops-exercise

# Using Docker Compose
docker-compose up -d
```

## Testing

The application includes health check endpoints and basic monitoring.

## Deployment

See the `.github/workflows/` directory for CI/CD pipeline configuration.

## Author

DevOps Intern Candidate - 2024
