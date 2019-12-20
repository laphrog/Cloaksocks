#!/bin/sh

echo -e "=============================================================================="
echo -e "========================= SHADOWSOCKS SERVER GO =============================="
echo -e "=============================================================================="

echo -e '[+] Show Container config'
echo -e "[!] Server IP : ${SERVER_IP}"
echo -e "[!] Server Port : ${SERVER_PORT}"
echo -e "[!] Encryption Method: ${ENCRYPTION}"
echo -e "[!] Password : ${PASSWORD}"

exec /app/shadowsocks-server -s "ss://${ENCRYPTION}:${PASSWORD}@${SERVER_IP}:${SERVER_PORT}" -verbose

exec "$@"
