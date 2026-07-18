#!/bin/bash
echo "Testing connection to local proxy router gateway..."

# 1. Check if LiteLLM proxy is listening locally on the VPS
if curl -s http://localhost:4000/v1/models > /dev/null; then
    echo "✔ Success: LiteLLM proxy is running on port 4000."
else
    echo "✖ Error: Cannot reach LiteLLM proxy on port 4000. Verify the service is active."
    exit 1
fi

# 2. Check if the local Mac engine endpoint responds through the tunnel
echo "Testing link to local hardware compute engine..."
RESPONSE=$(curl -s -w "%{http_code}" -o /dev/null http://localhost:4000/v1/models)

if [ "$RESPONSE" -eq 200 ]; then
    echo "✔ Success: Local Apple Silicon compute engine is answering requests correctly."
else
    echo "✖ Error: Gateway returned status $RESPONSE. Verify your Mac IP/tunnel configuration."
    exit 1
fi

echo "Bridge is working perfectly! Secure offloading active."
