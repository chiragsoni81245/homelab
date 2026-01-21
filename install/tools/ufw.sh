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
ufw --force reset

echo "[+] Default policies..."
ufw default deny incoming
ufw default allow outgoing

echo "[+] Allow SSH from LAN only..."
ufw allow from "$LAN_CIDR" to any port "$SSH_PORT" proto tcp comment "SSH from LAN"

echo "[+] Allow HTTP/HTTPS..."
ufw allow 80/tcp comment "HTTP"
ufw allow 443/tcp comment "HTTPS"

echo "[+] Allow ICMP (ping)..."
ufw allow proto icmp comment "Ping"

echo "[+] Rate limit SSH..."
ufw limit "$SSH_PORT"/tcp comment "SSH rate limiting"

echo "[+] IPv6 support..."
sed -i "s/^IPV6=.*/IPV6=${ENABLE_IPV6}/" /etc/default/ufw

echo "[+] Enabling UFW..."
ufw --force enable

echo "[+] Final UFW status:"
ufw status verbose

echo "✅ UFW setup complete."