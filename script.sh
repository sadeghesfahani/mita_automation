#!/bin/bash

# Replace with your username and token
username="your-username"
token="your-token"

# Replace with your repository's URL
repo="https://github.com/username/repo.git"

# Clone the repository
git clone "https://${username}:${token}@${repo}"
