#!/bin/bash

# Log file path
log_file="/var/log/deploy_automation.log"

# Log a message to the log file and show it in console
log_message() {
  message="$1"
  echo "$message" | tee -a "$log_file"
}

# Get username and token from environment variables
username="$GITHUB_USERNAME"
token="$GITHUB_TOKEN"

# Check if GITHUB_USERNAME and GITHUB_TOKEN are set
if [ -z "$username" ] || [ -z "$token" ]; then
  log_message "GITHUB_USERNAME and/or GITHUB_TOKEN are not set in environment variables. Exiting."
  sleep 3
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
  log_message "Cloning ${repo}"
  if git clone "https://${username}:${token}@${repo}" >> "$log_file" 2>&1; then
    log_message "Successfully cloned ${repo}"
  else
    log_message "Failed to clone ${repo}"
    sleep 3
    exit 1
  fi
done

# Log the end of the process
log_message "Cloning process completed at $(date)"
