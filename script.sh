#!/bin/bash

# Log file path
log_file="/var/log/deploy_automation.log"

# Get username and token from environment variables
username="$GITHUB_USERNAME"
token="$GITHUB_TOKEN"

# Check if GITHUB_USERNAME and GITHUB_TOKEN are set
if [ -z "$username" ] || [ -z "$token" ]; then
  echo "GITHUB_USERNAME and/or GITHUB_TOKEN are not set in environment variables. Exiting." >> "$log_file"
  exit 1
fi

# Navigate to the chosen directory
cd /var/www || { echo "Failed to navigate to /var/www" >> "$log_file"; exit 1; }

# Log the start of the process
echo "Starting the cloning process at $(date)" >> "$log_file"

# List of repositories to clone
repos=(
  "github.com/sadeghesfahani/Mita_The_Netherlands.git"
  "github.com/sadeghesfahani/MITA.git"
  "github.com/sadeghesfahani/Mitanor_frontend.git"
  "github.com/sadeghesfahani/MiTA-website.git"
  # Add more repositories as needed
)

# Loop through the repositories and clone them
for repo in "${repos[@]}"; do
  echo "Cloning ${repo}" >> "$log_file"
  if git clone "https://${username}:${token}@${repo}" >> "$log_file" 2>&1; then
    echo "Successfully cloned ${repo}" >> "$log_file"
  else
    echo "Failed to clone ${repo}" >> "$log_file"
  fi
done

# Log the end of the process
echo "Cloning process completed at $(date)" >> "$log_file"
