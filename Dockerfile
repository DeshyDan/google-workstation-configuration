# Use the predefined code-oss image from the specified GCP repository as the base image
FROM europe-west1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Download and add the HashiCorp GPG key to the list of trusted keys and add the HashiCorp repository to the list of APT sources
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update the package lists for upgrades and new package installations and Install the specified packages
RUN sudo apt update && \
sudo apt install -y dos2unix zsh curl wget git python3-pip gnupg openssh-server gcc make software-properties-common ca-certificates

# Clean up the local repository of retrieved package files to free up disk space
RUN apt-get clean

# Copy the workstation customization script into the image and make it executable
COPY workstation-customization.sh /etc/workstation-startup.d/300_workstation-customization.sh
RUN chmod +x /etc/workstation-startup.d/300_workstation-customization.sh