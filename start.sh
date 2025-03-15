#!/bin/sh

# Start tailscaled in the background
/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

# Wait for tailscaled to start up
sleep 2

# Connect to Tailscale network
/app/tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=codeengine-app

# Start FastAPI application
exec uvicorn main:app --host 0.0.0.0 --port 8080
