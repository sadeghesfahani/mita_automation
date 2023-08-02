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

# Navigate to the chosen directory or create it if it doesn't exist
if [ ! -d "/var/www" ]; then
  mkdir -p /var/www || { echo "Failed to create /var/www" >> "$log_file"; exit 1; }
fi

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

# Loop through the repositories and clone or pull them
for repo in "${repos[@]}"; do
  repo_url="https://${username}:${token}@${repo}"
  repo_name=$(basename "$repo" .git)
  if [ -d "$repo_name" ]; then
    log_message "Repository ${repo} already exists, pulling the latest version"
    cd "$repo_name" || { log_message "Failed to navigate to ${repo_name}"; exit 1; }
    if git pull "$repo_url" >> "$log_file" 2>&1; then
      log_message "Successfully pulled the latest version of ${repo}"
    else
      log_message "Failed to pull the latest version of ${repo}"
      exit 1
    fi
    cd .. || { log_message "Failed to navigate back"; exit 1; }
  else
    log_message "Cloning ${repo}"
    if git clone "$repo_url" >> "$log_file" 2>&1; then
      log_message "Successfully cloned ${repo}"
    else
      log_message "Failed to clone ${repo}"
      exit 1
    fi
  fi
done

# Log the end of the process
log_message "Cloning process completed at $(date)"
