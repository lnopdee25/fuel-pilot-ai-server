#!/bin/bash

# Start Ollama server in the background
ollama serve &

# Wait for server to be ready
echo "Waiting for Ollama server to start..."
until curl -s http://localhost:11434/api/tags > /dev/null 2>&1; do
  sleep 1
done
echo "Ollama server is running."

# Pull the Mistral model if not already present
if ! ollama list | grep -q "mistral"; then
  echo "Pulling Mistral model..."
  ollama pull mistral
  echo "Mistral model ready."
else
  echo "Mistral model already available."
fi

# Keep the server running in the foreground
wait
