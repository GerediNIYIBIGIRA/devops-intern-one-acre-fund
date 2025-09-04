#!/bin/bash
# DevOps Exercise Test Suite
# Tests both the bash script and Docker application

echo "🧪 DevOps Exercise Test Suite"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test results counters
PASSED=0
FAILED=0

# Function to print test results
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ((FAILED++))
    fi
}

echo ""
echo "📋 Testing Bash Script (disk_monitor.sh)"
echo "----------------------------------------"

# Test 1: Script exists and is executable
if [ -f "./disk_monitor.sh" ] && [ -x "./disk_monitor.sh" ]; then
    print_result 0 "Script exists and is executable"
else
    print_result 1 "Script missing or not executable"
fi

# Test 2: Script runs without errors
./disk_monitor.sh > /dev/null 2>&1
print_result $? "Script executes without errors"

# Test 3: Log file is created
if [ -f "./disk_monitor.log" ] || [ -f "/var/log/disk_monitor.log" ]; then
    print_result 0 "Log file is created"
    
    # Test 4: Log contains timestamps
    if grep -q "$(date '+%Y-%m-%d')" ./disk_monitor.log 2>/dev/null || grep -q "$(date '+%Y-%m-%d')" /var/log/disk_monitor.log 2>/dev/null; then
        print_result 0 "Log contains proper timestamps"
    else
        print_result 1 "Log missing timestamps"
    fi
else
    print_result 1 "No log file created"
fi

# Test 5: Script handles low threshold (simulate warning)
cp disk_monitor.sh disk_monitor_test.sh
sed -i 's/THRESHOLD=80/THRESHOLD=1/' disk_monitor_test.sh
./disk_monitor_test.sh > /dev/null 2>&1
if [ $? -eq 1 ]; then  # Should exit with error code 1 for high usage
    print_result 0 "Script properly detects high disk usage"
else
    print_result 1 "Script doesn't detect high disk usage"
fi
rm -f disk_monitor_test.sh

echo ""
echo "🐳 Testing Docker Application"
echo "-----------------------------"

# Test 6: Docker container is running
if docker ps --filter name=devops-app --format "{{.Names}}" | grep -q "devops-app"; then
    print_result 0 "Docker container is running"
    
    # Test 7: Main endpoint responds
    if curl -s http://localhost:8080/ > /dev/null 2>&1; then
        print_result 0 "Main endpoint (/) responds"
        
        # Test 8: Main endpoint returns JSON
        if curl -s http://localhost:8080/ | jq . > /dev/null 2>&1; then
            print_result 0 "Main endpoint returns valid JSON"
        else
            print_result 1 "Main endpoint doesn't return valid JSON"
        fi
    else
        print_result 1 "Main endpoint (/) not accessible"
    fi
    
    # Test 9: Health endpoint responds
    if curl -s http://localhost:8080/health > /dev/null 2>&1; then
        print_result 0 "Health endpoint responds"
        
        # Test 10: Health endpoint returns system info
        if curl -s http://localhost:8080/health | jq '.system_info' > /dev/null 2>&1; then
            print_result 0 "Health endpoint returns system information"
        else
            print_result 1 "Health endpoint missing system information"
        fi
    else
        print_result 1 "Health endpoint not accessible"
    fi
    
    # Test 11: Container resource usage is reasonable
    CPU_USAGE=$(docker stats devops-app --no-stream --format "{{.CPUPerc}}" | sed 's/%//')
    if (( $(echo "$CPU_USAGE < 50" | bc -l) )); then
        print_result 0 "Container CPU usage is reasonable (<50%)"
    else
        print_result 1 "Container CPU usage is high (>50%)"
    fi
    
else
    print_result 1 "Docker container is not running"
    print_result 1 "Skipping application endpoint tests"
    print_result 1 "Skipping application endpoint tests"
    print_result 1 "Skipping application endpoint tests"
    print_result 1 "Skipping application endpoint tests"
    print_result 1 "Skipping application endpoint tests"
fi

# Test 12: Port 8080 is listening
if netstat -tln | grep -q ":8080 "; then
    print_result 0 "Port 8080 is listening"
else
    print_result 1 "Port 8080 is not listening"
fi

echo ""
echo "🔄 Load Testing"
echo "---------------"

# Test 13: Application handles concurrent requests
if docker ps --filter name=devops-app --format "{{.Names}}" | grep -q "devops-app"; then
    echo "Sending 5 concurrent requests..."
    for i in {1..5}; do
        curl -s http://localhost:8080/ > /dev/null &
    done
    wait
    
    # Check if all requests completed successfully
    if [ $? -eq 0 ]; then
        print_result 0 "Application handles concurrent requests"
    else
        print_result 1 "Application struggles with concurrent requests"
    fi
else
    print_result 1 "Cannot test concurrent requests - container not running"
fi

echo ""
echo "📊 Test Results Summary"
echo "======================"
echo -e "✅ Passed: ${GREEN}$PASSED${NC}"
echo -e "❌ Failed: ${RED}$FAILED${NC}"
echo -e "📈 Success Rate: $(( PASSED * 100 / (PASSED + FAILED) ))%"

if [ $FAILED -eq 0 ]; then
    echo -e "\n🎉 ${GREEN}All tests passed! Your DevOps exercise is working perfectly.${NC}"
    exit 0
else
    echo -e "\n⚠️  ${YELLOW}Some tests failed. Please check the issues above.${NC}"
    exit 1
fi
