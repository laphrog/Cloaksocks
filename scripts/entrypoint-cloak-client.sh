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
echo -e "[!] Transport : \t${TRANSPORT}"
echo -e "[!] Method : \t\t${METHOD}"
echo -e "[!] Encryption : \t${ENCRYPTION}"
echo -e "[!] UID : \t\t${CLIENTUID}"
echo -e "[!] Public Key : \t${PUBLICKEY}"
echo -e "[!] Server Name : \t${SERVERNAME}"
echo -e "[!] Connection Number : ${CONNECTIONNUM}"
echo -e "[!] Browser : \t\t${BROWSER}"
echo -e "[!] Server IP : \t${SERVER_IP}"
echo -e "[!] Local Port : \t${LOCAL_PORT}"
echo -e "[!] Admin UID : \t${ADMINUID}"
echo -e "[+] Happy Domain Fronting :)"

exec "$@"
