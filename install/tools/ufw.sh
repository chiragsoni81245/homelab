#!/bin/bash

### ===== CONFIG =====
LAN_CIDR="$(yq '.server.lan_cidr' "$HOMELAB_CONFIG")"
SSH_PORT="22"
ENABLE_IPV6="$(yq '.ufw.enable_ipv6' "$HOMELAB_CONFIG")"
### ==================

echo "[+] Installing UFW..."
sudo apt update -y
sudo apt install -y ufw

echo "[+] Resetting UFW..."
sudo ufw --force reset

echo "[+] Default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "[+] Allow SSH from LAN only..."
sudo ufw allow from "$LAN_CIDR" to any port "$SSH_PORT" proto tcp comment "SSH from LAN"

echo "[+] Allow HTTP/HTTPS..."
sudo ufw allow 80/tcp comment "HTTP"
sudo ufw allow 443/tcp comment "HTTPS"

echo "[+] Allow ICMP (ping)..."
sudo ufw allow proto icmp comment "Ping"

echo "[+] Rate limit SSH..."
sudo ufw limit "$SSH_PORT"/tcp comment "SSH rate limiting"

echo "[+] IPv6 support..."
sudo sed -i "s/^IPV6=.*/IPV6=${ENABLE_IPV6}/" /etc/default/ufw

echo "[+] Enabling UFW..."
sudo ufw --force enable

echo "[+] Final UFW status:"
sudo ufw status verbose

echo "✅ UFW setup complete."