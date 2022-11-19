#!/bin/sh

echo
echo
echo -e "=============================================================================="
echo -e "============== Cloaksocks script for docker-compose automation ==============="
echo -e "=============================================================================="
echo

DefIP=$(hostname -I | awk '{print $1}')

KEYPAIRS=$(/root/shelldev/cloak-shadowsocks-docker/bin/ck-server -key)
PrivateKey=$(echo $KEYPAIRS | cut -d" " -f13)
PublicKey=$(echo $KEYPAIRS | cut -d" " -f5)

CloakUID=$(/root/shelldev/cloak-shadowsocks-docker/bin/ck-server -uid | cut -d" " -f4)


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
	ADMINUID=$(/root/shelldev/cloak-shadowsocks-docker/bin/ck-server -uid | cut -d" " -f4)
	echo "Your AdminUID: $ADMINUID";;

3)
	continue;;
esac



read -e -p " " -i "" L
