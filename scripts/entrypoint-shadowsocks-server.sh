#!/bin/sh

echo -e "=============================================================================="
echo -e "========================= SHADOWSOCKS SERVER GO =============================="
echo -e "=============================================================================="

echo -e '[+] Show Container config'
echo -e "[!] Server IP : \t${SERVER_IP}"
echo -e "[!] Server Port : \t${SERVER_PORT}"
echo -e "[!] Encryption Method:  ${ENCRYPTION}"
echo -e "[!] Password : \t\t${PASSWORD}"
echo -e "[+] See Cloak container logs for Connection info."

exec /app/shadowsocks-server -s "ss://${ENCRYPTION}:${PASSWORD}@${SERVER_IP}:${SERVER_PORT}"

exec "$@"
