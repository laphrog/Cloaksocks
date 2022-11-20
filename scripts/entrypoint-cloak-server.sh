#!/bin/sh

echo -e "=============================================================================="
echo -e "========================= CLOAK DOMAIN FRONTING =============================="
echo -e "=============================================================================="

sed -i "s|LOCAL_IP|${LOCAL_IP}|" /app/config.json
sed -i "s|LOCAL_PORT|${LOCAL_PORT}|" /app/config.json
sed -i "s|BYPASSUID|${BYPASSUID}|" /app/config.json
sed -i "s|REDIRADDR|${REDIRADDR}|" /app/config.json
sed -i "s|PRIVATEKEY|${PRIVATEKEY}|" /app/config.json
sed -i "s|ADMINUID|${ADMINUID}|" /app/config.json
sed -i "s|SERVERNAME|${REDIRADDR}|" /app/config.json
sed -i "s|BINDPORT|${BINDPORT}|" /app/config.json

echo -e '[+] Config.json generated successfully.'
echo -e '[+] Show Container config'
echo -e "[!] Local IP : \t\t${LOCAL_IP}"
echo -e "[!] Local Port : \t${LOCAL_PORT}"
echo -e "[!] Method : \t\t${METHOD}"
echo -e "[!] BypassUID : \t${BYPASSUID}"
echo -e "[!] Server Name : \t${REDIRADDR}"
echo -e "[!] PrivateKey : \t${PRIVATEKEY}"
echo -e "[!] AdminUID : \t\t${ADMINUID}"
echo -e "[!] PublicKey : \t${PUBLICKEY}"
echo -e "[!] SS Encryption : \t${ENCRYPTION}"
echo -e "[!] SS Password : \t${PASSWORD}"
echo -e "[+] Happy Domain Fronting :)"

SERVER_BASE64=$(printf "%s" "$ENCRYPTION:$PASSWORD" | base64)
SERVER_CLOAK_ARGS="ck-client;UID=$BYPASSUID;PublicKey=$PUBLICKEY;ServerName=$REDIRADDR;TicketTimeHint=3600;MaskBrowser=chrome;NumConn=4"
SERVER_CLOAK_ARGS=$(printf "%s" "$SERVER_CLOAK_ARGS" | curl -Gso /dev/null -w %{url_effective} --data-urlencode @- "" | cut -c 3-)
SERVER_BASE64="ss://$SERVER_BASE64@$LOCAL_IP:$BINDPORT?plugin=$SERVER_CLOAK_ARGS"
echo "Download Cloak Android Client from https://github.com/cbeuw/Cloak-android/releases"
echo "Download Cloak PC Client from https://github.com/cbeuw/Cloak/releases"
echo "Make sure you have the ck-plugin installed and then Scan this QR:"
echo
qrencode -t ansiutf8 "$SERVER_BASE64"
echo
echo "Or just use the link below:"
echo $SERVER_BASE64

exec "$@"
