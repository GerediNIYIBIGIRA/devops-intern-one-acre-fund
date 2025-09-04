# DevOps Exercise Repository

This repository contains the deliverables for my DevOps Intern take-home exercise.

## Project Structure

```
devops-exercise/
├── app.py                    # Flask web application
├── Dockerfile               # Container configuration
├── docker-compose.yml       # Multi-service orchestration
├── requirements.txt         # Python dependencies
├── disk_monitor.sh          # Bash script for disk monitoring
├── test_suite.sh           # Comprehensive test suite
├── run-complete-demo.sh    # Full demo script
├── k8s/                    # Kubernetes manifests
│   ├── configmap.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── backups/                # Backup utilities
│   ├── 20250904/          # Daily backup archives
│   └── recovery-script.sh
└── submission-package/     # Final submission artifacts
```

## Contents

- `app.py` - Flask web application with health check endpoints
- `disk_monitor.sh` - Bash script for monitoring disk usage with logging
- `Dockerfile` - Container configuration for the web app
- `docker-compose.yml` - Multi-service orchestration
- `k8s/` - Kubernetes deployment manifests
- `test_suite.sh` - Automated test suite with 92% pass rate
- `backups/` - Backup and recovery utilities
- `ci-cd.yml/` - find it in this path devops-exercise\.github\workflows\ci-cd.md: This workflow does the following automatically whenever you push code or create a PR:

Tests your Python code on multiple Python versions.

Measures test coverage.

Performs a security scan.

Builds a Docker image.

Verifies that the Docker container runs correctly.



## Getting Started

### Prerequisites
- Python 3.9+
- Docker & Docker Compose
- Kubernetes (optional)
- Git

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Access the application
curl http://localhost:8080
```

### Docker Usage
```bash
# Build the image
docker build -t devops-exercise .

# Run the container
docker run -p 8080:8080 devops-exercise

# Using Docker Compose
docker-compose up -d
```

## API Endpoints

- `GET /` - Main application endpoint (returns JSON)
- `GET /health` - Health check endpoint with system information
- Port: `8080` (not 5000 as commonly used)

## Testing

Run the comprehensive test suite:
```bash
./test_suite.sh
```

Current test results: **12/13 tests passing (92% success rate)**

The test suite covers:
- Bash script functionality and error handling
- Docker container health and performance
- API endpoint responses and load testing
- System resource monitoring

## Monitoring

- `disk_monitor.sh` - Monitors disk usage with configurable thresholds
- Generates timestamped logs in `disk_monitor.log`
- Automated backup system with date-based organization

## Kubernetes Deployment

Deploy to Kubernetes cluster:
```bash
kubectl apply -f k8s/
```

## Backup & Recovery

The project includes automated backup utilities:
- Daily backup archives in `backups/YYYYMMDD/` format
- Recovery scripts for disaster recovery scenarios

## Demo

Run the complete demonstration:
```bash
./run-complete-demo.sh
```

## Troubleshooting

If you encounter the failing test in `disk_monitor.sh`, check:
1. Script permissions: `chmod +x disk_monitor.sh`
2. Log file write permissions
3. Disk space availability for logging

## Author

DevOps Intern Candidate - September 2025(Geredi Niyibigira)