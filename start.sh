#!/bin/bash
set -e

# Render uses PORT env var (default 10000) — Ollama must bind to it
export OLLAMA_HOST="0.0.0.0:${PORT:-11434}"

echo "Starting Ollama on port ${PORT:-11434}..."
ollama serve &
SERVER_PID=$!

# Wait for server to be ready
echo "Waiting for Ollama server..."
for i in $(seq 1 60); do
  if curl -s "http://localhost:${PORT:-11434}/api/tags" > /dev/null 2>&1; then
    echo "Ollama server is running."
    break
  fi
  sleep 2
done

# Use phi3 — lightweight but capable, fits in 4GB RAM
MODEL="tinyllama"

if ! ollama list 2>/dev/null | grep -q "$MODEL"; then
  echo "Pulling $MODEL model..."
  ollama pull "$MODEL"
  echo "$MODEL model ready."
else
  echo "$MODEL model already available."
fi

echo "FuelPilot AI server is ready with $MODEL."

# Keep the server running
wait $SERVER_PID
