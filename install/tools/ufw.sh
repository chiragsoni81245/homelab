#!/bin/bash

### ===== CONFIG =====
LAN_CIDR="$(yq '.server.lan_cidr' "$HOMELAB_CONFIG")"
SSH_PORT="22"
ENABLE_IPV6="$(yq '.ufw.enable_ipv6' "$HOMELAB_CONFIG")"
### ==================

echo -e "\n[+] Installing UFW..."
sudo apt update -y
sudo apt install -y ufw

echo -e "\n[+] Resetting UFW..."
sudo ufw --force reset

echo -e "\n[+] Default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo -e "\n[+] Allow SSH from LAN only..."
sudo ufw allow from "$LAN_CIDR" to any port "$SSH_PORT" proto tcp comment "SSH from LAN"

echo -e "\n[+] Allow HTTP/HTTPS..."
sudo ufw route allow 80/tcp comment "HTTP"
sudo ufw route allow 443/tcp comment "HTTPS"

echo -e "\n[+] Rate limit SSH..."
sudo ufw limit "$SSH_PORT"/tcp comment "SSH rate limiting"

echo -e "\n[+] IPv6 support..."
sudo sed -i "s/^IPV6=.*/IPV6=${ENABLE_IPV6}/" /etc/default/ufw

echo -e "\n[+] Patch after.rules for docker port bypass issue fix..."
sudo tee -a /etc/ufw/after.rules < ~/.local/share/homelab/config/ufw/after.rules > /dev/null
sudo ufw allow from 10.200.0.0/16 to 10.200.0.0/16 comment "Container <-> Host <-> Container"

echo -e "\n[+] Allow Samba on lan network..."
sudo ufw allow from "$LAN_CIDR" to any port 445 proto tcp comment "Samba from LAN on 445"
sudo ufw allow from "$LAN_CIDR" to any port 139 proto tcp comment "Samba from LAN on 139"
sudo ufw allow from "$LAN_CIDR" to any port 137 proto udp comment "Samba from LAN on 137"
sudo ufw allow from "$LAN_CIDR" to any port 138 proto udp comment "Samba from LAN on 138"

echo -r "\n[+] Allow Nginx Proxy Admin to lan network..."
sudo ufw route allow from "$LAN_CIDR" to any port 81 proto tcp comment "Nginx Proxy Admin"

echo -r "\n[+] Allow DNS Server for lan network..."
sudo ufw allow from "$LAN_CIDR" to any port 53 proto udp comment "DNS Server"
sudo ufw allow from "$LAN_CIDR" to any port 53 proto tcp comment "DNS Server"
sudo ufw allow from "$LAN_CIDR" to any port 953 proto tcp comment "DNS Server"

echo -e "\n[+] Enabling UFW..."
sudo ufw --force enable

echo -e "\n[+] Reloading config..."
sudo ufw reload

echo -e "\n[+] Final UFW status:"
sudo ufw status verbose

echo "✅ UFW setup complete."