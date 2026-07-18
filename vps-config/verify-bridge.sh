#!/bin/bash

echo "Checking LLM Bridge Connection..."
echo "---------------------------------"

# Test the router proxy using native Ollama format
RESPONSE=$(curl -s -X POST http://localhost:4000/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi4-mini",
    "prompt": "Respond with the word PASS.",
    "stream": false
  }')

echo "Raw Response from Proxy:"
echo "$RESPONSE"
echo "---------------------------------"

if [[ $RESPONSE == *"PASS"* ]]; then
  echo "✅ SUCCESS: The bridge is working perfectly end-to-end!"
else
  echo "❌ ERROR: Verification failed. Check simple-router.py terminal log."
  exit 1
fi
