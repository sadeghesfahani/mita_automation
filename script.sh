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
  mkdir -p /var/www || {
    echo "Failed to create /var/www" >>"$log_file"
    exit 1
  }
fi

cd /var/www || {
  echo "Failed to navigate to /var/www" >>"$log_file"
  exit 1
}

# Log the start of the process
echo "Starting the cloning process at $(date)" >>"$log_file"

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
    cd "$repo_name" || {
      log_message "Failed to navigate to ${repo_name}"
      exit 1
    }
    if git pull "$repo_url" >>"$log_file" 2>&1; then
      log_message "Successfully pulled the latest version of ${repo}"
    else
      log_message "Failed to pull the latest version of ${repo}"
      exit 1
    fi
    cd .. || {
      log_message "Failed to navigate back"
      exit 1
    }
  else
    log_message "Cloning ${repo}"
    if git clone "$repo_url" >>"$log_file" 2>&1; then
      log_message "Successfully cloned ${repo}"
    else
      log_message "Failed to clone ${repo}"
      exit 1
    fi
  fi
done

# Log the end of the process
log_message "Cloning process completed at $(date)"

# install nginx and configure it
sudo apt update
sudo apt install nginx -y

# hardening web server
# Reset all rules to default
ufw --force reset
log_message "Reset all rules to default is done"

# give access to nginx
sudo ufw allow 'Nginx Full'
log_message "give access to nginx is done"

# Allow incoming traffic on SSH (port 22), HTTP (port 80), and HTTPS (port 443)
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

log_message "Allow incoming traffic on SSH (port 22), HTTP (port 80), and HTTPS (port 443) is done"

# Deny all other incoming connections
ufw default deny incoming

log_message "Deny all other incoming connections is done"

# Allow all outgoing connections
ufw default allow outgoing

log_message "Allow all outgoing connections is done"

# Enable the firewall
ufw --force enable

log_message "Enable the firewall is done"

# Check the status to make sure the rules were applied correctly
ufw_status=$(ufw status verbose)
log_message "ufw status: ${ufw_status}"

# install docker desktop

# Add docker to repository (install prerequisites)
sudo apt-get install ca-certificates curl gnupg -y
log_message "Installing packages is done"

# Add Docker’s official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
log_message "GOG key sets up is done"

# Set up the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

log_message "Setting up the repository is done."

# update the apt package index
sudo apt-get update
log_message "update the apt package index is done"

# install the latest version of Docker Engine and containerd
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y || {
  log_message "Failed to install Docker components"
  exit 1
}
log_message "installing docker is done"

# Start and enable the Docker service
sudo systemctl start docker
sudo systemctl enable docker || {
  log_message "Failed to start or enable Docker"
  exit 1
}
log_message "Running at the startup is set"


# install nodejs

sudo apt update
sudo apt install nodejs npm -y
sudo apt install npm -y

# make projects ready to run

cd /var/www/MITA || {
  log_message "Failed to navigate to /var/www/MITA"
  exit 1
}

docker-compose up -d


cd /var/www/Mita_The_Netherlands || {
  log_message "Failed to navigate to /var/www/Mita_The_Netherlands"
  exit 1
}
docker-compose -f ./backend/docker-compose.prod.yml up -d


#cd /var/www/Mitanor_frontend || {
#  log_message "Failed to navigate to /var/www/Mitanor_frontend"
#  exit 1
#}
#
#npm install
#npm run build

