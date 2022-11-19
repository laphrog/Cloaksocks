#!/bin/sh

echo
echo
echo -e "=============================================================================="
echo -e "============== Cloaksocks script for docker-compose automation ==============="
echo -e "=============================================================================="
echo



InstallDep(){
	rpm -qa | grep qrencode
	if [ $?==1 ]
	then
		yum install qrencode
	fi
}

QueryInfo(){
	DefIP=$(hostname -I | awk '{print $1}')
	KEYPAIRS=$(bin/ck-server -key)
	PrivateKey=$(echo $KEYPAIRS | cut -d" " -f13)
	PublicKey=$(echo $KEYPAIRS | cut -d" " -f5)
	CloakUID=$(bin/ck-server -uid | cut -d" " -f4)
}

ReadArgs(){
	read -e -p "Enter your ip address: " -i "$DefIP" LOCAL_IP
	read -e -p "Enter desired port for Shadowsocks: " -i "8399" LOCAL_PORT
	read -e -p "Enter ByPassUID: " -i "$CloakUID" BYPASSUID
	read -e -p "Enter PrivateKey: " -i "$PrivateKey" PRIVATEKEY
	read -e -p "Enter PublicKey: " -i "$PublicKey" PUBLICKEY
	read -e -p "Enter Encryption method: " -i "AEAD_CHACHA20_POLY1305" ENCRYPTION  #List
	stty -echo
	read -p "Enter Password: " -i "" PASSWORD
	stty echo
	echo
	echo

	echo "Enter AdminUID (Optional): "
	echo "1) UseByPassUID as AdminUID"
	echo "2) Generate new UID and set it as AdminUID"
	echo "3) Ignore (Recommended)"
	echo
	read -r -p "Please enter a number: " OPTIONS

	case $OPTIONS in
	1)
		ADMINUID=$BYPASSUID;;
	
	2)
		ADMINUID=$(bin/ck-server -uid | cut -d" " -f4)
		echo "Your AdminUID: $ADMINUID";;
	
	*)
		continue;;
	esac
}

ReplaceArgs(){
	cp docker-compose-server.yaml docker-compose.yml
	sed -i "s|\$LOCAL_IP|${LOCAL_IP}|" docker-compose.yml 
	sed -i "s|\$LOCAL_PORT|${LOCAL_PORT}|" docker-compose.yml
	sed -i "s|\$BYPASSUID|${BYPASSUID}|" docker-compose.yml
	sed -i "s|\$PRIVATEKEY|${PRIVATEKEY}|" docker-compose.yml
	sed -i "s|\$PUBLICKEY|${PUBLICKEY}|" docker-compose.yml
	sed -i "s|\$ENCRYPTION|${ENCRYPTION}|" docker-compose.yml
	sed -i "s|\$PASSWORD|${PASSWORD}|" docker-compose.yml
	sed -i "s|\$ADMINUID|${ADMINUID}|" docker-compose.yml
}

ShowConnectionInfo(){
	SERVER_BASE64=$(printf "%s" "$ENCRYPTION:$PASSWORD" | base64)
	SERVER_CLOAK_ARGS="ck-client;UID=$BYPASSUID;PublicKey=$PUBLICKKEY;ServerName=REDIRADDR;TicketTimeHint=3600;MaskBrowser=chrome;NumConn=4"
	SERVER_CLOAK_ARGS=$(printf "%s" "$SERVER_CLOAK_ARGS" | curl -Gso /dev/null -w %{url_effective} --data-urlencode @- "" | cut -c 3-)
	SERVER_BASE64="ss://$SERVER_BASE64@$PUBLIC_IP:$PORT?plugin=$SERVER_CLOAK_ARGS"
	qrencode -t ansiutf8 "$SERVER_BASE64"
}

if [ -x bin/ck-server ]
then
        QueryInfo
else
        chmod +x ck-server
        QueryInfo
fi



docker-compose up -d




#sed -i "s||${}|" docker-compose.yml
#read -e -p " " -i "" L
