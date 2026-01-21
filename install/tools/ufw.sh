#!/bin/bash

### ===== CONFIG =====
LAN_CIDR="$(yq '.server.lan_cidr' "$HOMELAB_CONFIG")"
SSH_PORT="22"
ENABLE_IPV6="$(yq '.ufw.enable_ipv6' "$HOMELAB_CONFIG")"
### ==================

echo "\n[+] Installing UFW..."
sudo apt update -y
sudo apt install -y ufw

echo "\n[+] Resetting UFW..."
sudo ufw --force reset

echo "\n[+] Default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "\n[+] Allow SSH from LAN only..."
sudo ufw allow from "$LAN_CIDR" to any port "$SSH_PORT" proto tcp comment "SSH from LAN"

echo "\n[+] Allow HTTP/HTTPS..."
sudo ufw allow 80/tcp comment "HTTP"
sudo ufw allow 443/tcp comment "HTTPS"

echo "\n[+] Allow ICMP (ping)..."
sudo ufw allow proto icmp comment "Ping"

echo "\n[+] Rate limit SSH..."
sudo ufw limit "$SSH_PORT"/tcp comment "SSH rate limiting"

echo "\n[+] IPv6 support..."
sudo sed -i "s/^IPV6=.*/IPV6=${ENABLE_IPV6}/" /etc/default/ufw

echo "\n[+] Patch after.rules for docker port bypass issue fix..."
sudo cat ~/.local/share/homelab/config/ufw/after.rules >> /etc/ufw/after.rules

echo "\n[+] Enabling UFW..."
sudo ufw --force enable

echo "\n[+] Reloading config..."
sudo ufw reload

echo "\n[+] Final UFW status:"
sudo ufw status verbose

echo "✅ UFW setup complete."