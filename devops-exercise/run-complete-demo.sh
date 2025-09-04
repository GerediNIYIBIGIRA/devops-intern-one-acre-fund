#!/bin/bash
# Complete demonstration script for DevOps Exercise

echo "🚀 DevOps Exercise Complete Demonstration"
echo "========================================="

echo "1. Running disk monitor..."
./disk_monitor.sh

echo -e "\n2. Building and running Docker container..."
docker build -t devops-exercise:demo .
docker run -d --name demo-app -p 8080:5000 devops-exercise:demo
sleep 3

echo -e "\n3. Testing application..."
curl -s http://localhost:8080/health | jq . || curl -s http://localhost:8080/health

echo -e "\n4. Container status..."
docker ps --filter name=demo-app

echo -e "\n5. Application logs..."
docker logs demo-app --tail 10

echo -e "\n6. Cleanup..."
docker stop demo-app
docker rm demo-app

echo -e "\n✅ Demonstration complete!"
echo "See EXERCISE-REPORT.md for detailed documentation."
