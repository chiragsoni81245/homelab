#!/bin/bash

VERSION="v1.1.0"

# Install sync-tool
if [ ! -f '/usr/local/bin/sync-tool' ]; then
  sudo wget -q "https://github.com/chiragsoni81245/sync-tool/releases/download/$VERSION/sync-tool" -O /usr/local/bin/sync-tool
  sudo chmod +x /usr/local/bin/sync-tool
fi

# Create the base directory if not there
if [ ! -d '/etc/sync-tool' ]; then
    sudo mkdir /etc/sync-tool
fi

# Use default configuration if one does not exists already
if [ ! -f '/etc/sync-tool/config.yaml' ]; then
  sudo wget -q "https://raw.githubusercontent.com/chiragsoni81245/sync-tool/$VERSION/config.yaml" -O /etc/sync-tool/config.yaml

  # Load the sync-tool configuration from Homelab configuration
  sudo yq -i ". = load(\"$HOMELAB_CONFIG\").sync-tool" /etc/sync-tool/config.yaml
fi

if [ ! -f '/etc/systemd/system/sync-tool.service' ]; then
cat << 'EOF' | sudo tee /etc/systemd/system/sync-tool.service > /dev/null
[Unit]
Description=Sync Tool GitHub Directory Sync Service
After=network.target

[Service]
ExecStart=/usr/local/bin/sync-tool start --config /etc/sync-tool/config.yaml
Restart=on-failure
WorkingDirectory=/etc/sync-tool

[Install]
WantedBy=multi-user.target
EOF
fi

# Reload systemd to pick up the new service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable --now sync-tool.service
