#!/bin/sh

echo
echo
echo  "================================ Cloaksocks =================================="
echo  "=============================================================================="
echo  "=============Shadowsocks over Cloak deployed via docker-compose==============="
echo  "=============================================================================="
echo  "=============================================================================="
echo


InstallDep(){
	rpm -qa | grep docker-ce
	if [ $?==1 ]
	then
		yum install -y yum-utils
		yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		yum install docker-ce
		systemctl start docker
	fi
	
	docker-compose version
	if [ $?==1 ]
	then
		curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" \
		-o /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
	fi
	
	rpm -qa | grep qrencode
	if [ $?==1 ]
	then
		yum install qrencode
	fi
}

QueryInfo(){
	DefIP=$(hostname -I | awk '{print $1}')
	KEYPAIRS=$(bin/ck_server -key)
	PrivateKey=$(echo $KEYPAIRS | cut -d" " -f13)
	PublicKey=$(echo $KEYPAIRS | cut -d" " -f5)
	CloakUID=$(bin/ck_server -uid | cut -d" " -f4)
}

ReadArgs(){
	read -e -p "Enter your ip address: " -i "$DefIP" LOCAL_IP
	read -e -p "Enter Shadowsocks Port: " -i "8399" LOCAL_PORT
	read -e -p "Enter ByPassUID: " -i "$CloakUID" BYPASSUID
	read -e -p "Enter PrivateKey: " -i "$PrivateKey" PRIVATEKEY
	read -e -p "Enter PublicKey: " -i "$PublicKey" PUBLICKEY
	read -e -p "Enter Encryption method: " -i "AEAD_CHACHA20_POLY1305" ENCRYPTION  #List
	read -e -p "Enter Cloak Port (443 is strongly recommended): " -i "443" BINDADDR
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

	echo "Enter Redirect Address: "
	echo "1) Cloudflare (1.0.0.1)"
	echo "2) www.bing.com"
	echo
	read -r -p "Select an Option or Enter an Address: " OPTIONS

	case $OPTIONS in
	1)
		REDIRADDR=1.0.0.1;;
	2)
		REDIRADDR=www.bing.com;;
	*)
		REDIRADDR=$OPTIONS;;
	esac
	
	echo "Redirect address set to: $REDIRADDR"
	echo
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
	sed -i "s|\$REDIRADDR|${REDIRADDR}|" docker-compose.yml
	sed -i "s|\$BINDADDR|${BINDADDR}|" docker-compose.yml
}

ShowConnectionInfo(){
	SERVER_BASE64=$(printf "%s" "$ENCRYPTION:$PASSWORD" | base64)
	SERVER_CLOAK_ARGS="ck-client;UID=$BYPASSUID;PublicKey=$PUBLICKEY;ServerName=$REDIRADDR;TicketTimeHint=3600;MaskBrowser=chrome;NumConn=4"
	SERVER_CLOAK_ARGS=$(printf "%s" "$SERVER_CLOAK_ARGS" | curl -Gso /dev/null -w %{url_effective} --data-urlencode @- "" | cut -c 3-)
	SERVER_BASE64="ss://$SERVER_BASE64@$LOCAL_IP:$LOCAL_PORT?plugin=$SERVER_CLOAK_ARGS"

	echo  "=============================================================================="
	echo  "=============================================================================="
	echo "Download Cloak Android Client from https://github.com/cbeuw/Cloak-android/releases"
	echo "Download Cloak PC Client from https://github.com/cbeuw/Cloak/releases"
	echo "Make sure you have the ck-plugin installed and then Scan this QR:"
	echo
	qrencode -t ansiutf8 "$SERVER_BASE64"

	echo  "=============================================================================="
	echo  "=============================================================================="
	echo "Or just use the link below:"
	echo $SERVER_BASE64
	echo
}


if [ -x bin/ck_server ]
then
        QueryInfo
else
        chmod +x bin/ck_server
        QueryInfo
fi


ReadArgs
ReplaceArgs
docker-compose up -d
ShowConnectionInfo
