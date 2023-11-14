#!/bin/bash

# Replace with your URL and JSON file path
URL="http://localhost:3000/manifests/hunter"
JSON_FILE="./target/dev/manifest.json"

curl -X POST -H "Content-Type: application/json" -d @"$JSON_FILE" "$URL"
