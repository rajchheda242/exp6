#!/bin/bash
# Wait for Flask app to be ready
MAX_ATTEMPTS=30
ATTEMPT=0

echo "Waiting for Flask app to start..."
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -s -f http://127.0.0.1:5000/ > /dev/null 2>&1; then
        echo "Flask app is ready!"
        exit 0
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo "Attempt $ATTEMPT/$MAX_ATTEMPTS - app not ready yet..."
    sleep 1
done

echo "Flask app failed to start within $MAX_ATTEMPTS seconds"
exit 1
