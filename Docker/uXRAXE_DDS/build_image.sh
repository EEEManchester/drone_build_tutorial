#!/bin/bash

# Set image name and tag
IMAGE_NAME="xrace_px4"
TAG="latest"

# Print information
echo "Building Docker image: $IMAGE_NAME:$TAG"
echo "---------------------------------------------"

# Build the Docker image
docker build -t $IMAGE_NAME:$TAG .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "---------------------------------------------"
    echo "Build successful!"
else
    echo "---------------------------------------------"
    echo "Build failed!"
fi