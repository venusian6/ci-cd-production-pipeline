#!/bin/bash
set -e

IMAGE="$1"
NGINX_CONF="/etc/nginx/conf.d/cicd.conf"

# Determine active container
ACTIVE_CONTAINER=$(docker ps --filter "name=cicd-" --format "{{.Names}}" | head -n1)

if [ "$ACTIVE_CONTAINER" == "cicd-blue" ]; then
  NEW_CONTAINER="cicd-green"
  NEW_PORT=5001
else
  NEW_CONTAINER="cicd-blue"
  NEW_PORT=5000
fi

echo "Preparing $NEW_CONTAINER on port $NEW_PORT"

# 🔑 IMPORTANT: ensure container name is free
docker rm -f "$NEW_CONTAINER" 2>/dev/null || true

# Start new container
docker run -d \
  --name "$NEW_CONTAINER" \
  -p "$NEW_PORT:5000" \
  -e APP_VERSION="$(date +%s)" \
  "$IMAGE"

# Health check
sleep 5
curl -f http://localhost:$NEW_PORT/health

echo "Switching Nginx to port $NEW_PORT"
sudo sed -i "s|proxy_pass http://127.0.0.1:.*;|proxy_pass http://127.0.0.1:$NEW_PORT;|" "$NGINX_CONF"
sudo nginx -t
sudo systemctl reload nginx

# Stop old container (after traffic switch)
if [ -n "$ACTIVE_CONTAINER" ]; then
  docker rm -f "$ACTIVE_CONTAINER" || true
fi

echo "✅ Zero-downtime deployment successful"
