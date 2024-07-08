FROM europe-west1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN sudo apt update && sudo apt install -y dos2unix zsh curl wget git python3-pip gnupg openssh-server gcc make software-properties-common ca-certificates
RUN apt-get clean

# Install zsh
ENV ZSH=/opt/workstation/oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  git clone https://github.com/zsh-users/zsh-autosuggestions /opt/workstation/oh-my-zsh/plugins/zsh-autosuggestions && \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /opt/workstation/oh-my-zsh/custom/themes/powerlevel10k


# Install k9s
RUN curl -s https://api.github.com/repos/derailed/k9s/releases/latest \
| grep "browser_download_url.*Linux_amd64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - && mkdir -p /opt/workstation/bin && tar -xf k9s_Linux_amd64.tar.gz  -C /opt/workstation/bin

# Install extensions
RUN wget -O terraform.vsix $(curl -q https://open-vsx.org/api/hashicorp/terraform/linux-x64 | jq -r '.files.download') \
    && unzip terraform.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/terraform

RUN wget -O vscode-icons.vsix $(curl -q https://open-vsx.org/api/vscode-icons-team/vscode-icons | jq -r '.files.download') \
    && unzip vscode-icons.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/vscode-icons

# Copy workstation customization script
COPY workstation-customization.sh /etc/workstation-startup.d/300_workstation-customization.sh
RUN chmod +x /etc/workstation-startup.d/300_workstation-customization.sh