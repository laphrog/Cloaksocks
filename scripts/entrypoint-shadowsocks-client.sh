#!/bin/sh

echo -e "=============================================================================="
echo -e "========================= SHADOWSOCKS SERVER GO =============================="
echo -e "=============================================================================="

echo -e '[+] Show Container config'
echo -e "[!] Server IP : \t${SERVER_IP}"
echo -e "[!] Server Port : \t${SERVER_PORT}"
echo -e "[!] Local IP : \t\t${LOCAL_IP}"
echo -e "[!] Local Port : \t${LOCAL_PORT}"
echo -e "[!] Encryption Method:  ${ENCRYPTION}"
echo -e "[!] Password : \t\t${PASSWORD}"

exec /app/shadowsocks-client -c "ss://${ENCRYPTION}:${PASSWORD}@${SERVER_IP}:${SERVER_PORT}" -socks ${LOCAL_IP}:${LOCAL_PORT} -u

exec "$@"
