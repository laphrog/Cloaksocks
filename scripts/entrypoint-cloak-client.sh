#!/bin/sh

echo -e "=============================================================================="
echo -e "========================= CLOAK DOMAIN FRONTING =============================="
echo -e "=============================================================================="

sed -i "s|TRANSPORT|${TRANSPORT}|" /app/config.json
sed -i "s|METHOD|${METHOD}|" /app/config.json
sed -i "s|ENCRYPTION|${ENCRYPTION}|" /app/config.json
sed -i "s|CLIENTUID|${CLIENTUID}|" /app/config.json
sed -i "s|PUBLICKEY|${PUBLICKEY}|" /app/config.json
sed -i "s|SERVERNAME|${SERVERNAME}|" /app/config.json
sed -i "s|CONNECTIONNUM|${CONNECTIONNUM}|" /app/config.json
sed -i "s|BROWSER|${BROWSER}|" /app/config.json

echo -e '[+] Config.json generated successfully.'
echo -e '[+] Show Container config'
echo -e "[!] Transport : ${TRANSPORT}"
echo -e "[!] Method : ${METHOD}"
echo -e "[!] Encryption : ${ENCRYPTION}"
echo -e "[!] UID : ${CLIENTUID}"
echo -e "[!] Public Key : ${PUBLICKEY}"
echo -e "[!] Server Name : ${SERVERNAME}"
echo -e "[!] Connection Number : ${CONNECTIONNUM}"
echo -e "[!] Browser : ${BROWSER}"
echo -e "[+] Happy Domain Fronting :)"

exec "$@"
