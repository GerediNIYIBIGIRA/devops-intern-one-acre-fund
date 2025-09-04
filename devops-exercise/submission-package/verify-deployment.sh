#!/bin/bash
echo "=== DevOps Exercise - Deployment Verification ==="

echo "1. Testing Flask Application..."
if [ -f "app.py" ]; then
    echo "✅ Flask application file present"
else
    echo "❌ app.py not found"
fi

echo "2. Testing Docker Configuration..."
if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile present"
else
    echo "❌ Dockerfile not found"
fi

echo "3. Checking Documentation..."
[ -f "README.md" ] && echo "✅ README.md present" || echo "❌ README.md missing"
[ -f "FINAL-SUBMISSION-REPORT.md" ] && echo "✅ Final report present" || echo "❌ Final report missing"

echo "4. Verifying Project Structure..."
echo "📁 Project Contents:"
ls -la

echo "=== Verification Complete ==="
