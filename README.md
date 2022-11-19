# Cloaksocks (Shadowsocks over Cloak on Docker)
Cloak is a universal pluggable transport that cryptographically obfuscates proxy traffic as legitimate HTTPS traffic, disguises the proxy server as a normal web server, multiplexes traffic through a fixed amount of TCP connections and provides multi-user usage control.

Cloaksocks consists of scripts and Dockerfiles to enhance and simplify Shadowsocks/Cloak usage.

![Made with](https://img.shields.io/badge/Made%20with-Bash-red)
![Cloak version](https://img.shields.io/badge/Cloak_version-2.6.0-blue)
![ShadowSocks version](https://img.shields.io/badge/ShadowSocks_version-0.1.5-blue)
![Dockerfile](https://img.shields.io/badge/Dockerfile-Ready-brightgreen)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-Ready-brightgreen)
![Docker Build](https://img.shields.io/badge/Docker_Build-Automatic-brightgreen)
# Dockerfiles

|File name| Description |
|---|---|
|Dockerfile-cloak-server| Alpine container with Cloak Server |
|Dockerfile-shadowsocks-server| Alpine container with Golang ShadowSocks Server |

# How to utilize
You have many options:
### Using the shell script
Using `Cloaksocks.sh` is the recommended action:

```bash
chmod +x Cloaksocks.sh
./Cloaksocks.sh
```

Then follow the instructions. Fast and Simple.
The script creates a `docker-compose.yml` with your desired configuration and then starts the stack.

### Using docker-compose directly
If you want to manually configure the `docker-compose` file, make sure to check the "Supported Variables" section first.
Then simply edit and run `docker-compose-server.yaml`

```bash
docker-compose -f docker-compose-server.yaml up -d
```

### Using Docker Images or Dockerfile
Both Cloak(2.6.0) and Shadowsocks(0.1.5) are dockerized and available on hub.docker.com



# Supported Variables

## Cloak Server
| Key | Description |
| --- | --- |
| LOCAL_IP | Your server IP |
| LOCAL_PORT | Application listening port |
| METHOD | shadowsocks |
| BYPASSUID | UID Genetated by Cloak that is authorised without any restrictions. `ck-server -uid` |
| REDIRADDR | redirection address when the incoming traffic is not from a Cloak client (Ideally it should be set to a major website allowed by the censor.) |
| PRIVATEKEY | static curve25519 Diffie-Hellman private key encoded in base64. `ck-server -k` |
| ADMINUID | UID of the admin user in base64 (Optional) `ck-server -uid` |



## Cloak Client
| Key | Default value | Description |
| --- | --- | --- |
| TRANSPORT | direct | If the server host wishes you to connect to it directly, use direct. |
| METHOD | shadowsocks | the proxy method you are using. |
| ENCRYPTION | plain |  encryption algorithm you want Cloak to use. |
| CLIENTUID | UID obtained in the previous table | |
| PUBLICKEY | PubKey obtained in the previous table | is the static curve25519 public key, given by the server admin |
| SERVERNAME | 1.0.0.1 | domain you want to make your ISP or firewall think you are visiting. Better be the same value as REDIRADDR |
| CONNECTIONNUM | 4 | amount of underlying TCP connections you want to use |
| BROWSER | chrome | the browser you want to appear to be using. It's not relevant to the browser you are actually using. Currently, `chrome` and `firefox` are supported. |      
| LOCAL_PORT | 443 | |
| ADMINUID | Admin UID obtained in the previous table | |

## Shadowsocks Server
| Key | Default value | Description |
| --- | --- | --- |
| SERVER_IP | 0.0.0.0 | Application listening IP |
| SERVER_PORT | 8399 | Application listening Port |
| ENCRYPTION | AEAD_CHACHA20_POLY1305 | Encryption Method (`AES-256-CFB` is not supported) | 
| PASSWORD | `null` | Your password |

# Cloak Configuration
[Cloak Manual - Offical Repo.](https://github.com/cbeuw/Cloak/blob/master/README.md)

### Server
`RedirAddr` is the redirection address when the incoming traffic is not from a Cloak client. It should either be the same as, or correspond to the IP record of the `ServerName` field set in `ckclient.json`.

`BindAddr` is a list of addresses Cloak will bind and listen to (e.g. `[":443",":80"]` to listen to port 443 and 80 on all interfaces)

`ProxyBook` is a nested JSON section which defines the address of different proxy server ends. For instance, if OpenVPN server is listening on 127.0.0.1:1194, the pair should be `"openvpn":"127.0.0.1:1194"`. There can be multiple pairs. You can add any other proxy server in a similar fashion, as long as the name matches the `ProxyMethod` in the client config exactly (case-sensitive).

`PrivateKey` is the static curve25519 Diffie-Hellman private key encoded in base64.

`AdminUID` is the UID of the admin user in base64.

`BypassUID` is a list of UIDs that are authorised without any bandwidth or credit limit restrictions

`DatabasePath` is the path to userinfo.db. If userinfo.db doesn't exist in this directory, Cloak will create one automatically. **If Cloak is started as a Shadowsocks plugin and Shadowsocks is started with its working directory as / (e.g. starting ss-server with systemctl), you need to set this field as an absolute path to a desired folder. If you leave it as default then Cloak will attempt to create userinfo.db under /, which it doesn't have the permission to do so and will raise an error. See Issue #13.**

### Client
`UID` is your UID in base64.

`Transport` can be either `direct` or `CDN`. If the server host wishes you to connect to it directly, use `direct`. If instead a CDN is used, use `CDN`.

`PublicKey` is the static curve25519 public key, given by the server admin.

`ProxyMethod` is the name of the proxy method you are using.

`EncryptionMethod` is the name of the encryption algorithm you want Cloak to use. Note: Cloak isn't intended to provide transport security. The point of encryption is to hide fingerprints of proxy protocols and render the payload statistically random-like. If the proxy protocol is already fingerprint-less, which is the case for Shadowsocks, this field can be left as `plain`. Options are `plain`, `aes-gcm` and `chacha20-poly1305`.

`ServerName` is the domain you want to make your ISP or firewall think you are visiting.

`NumConn` is the amount of underlying TCP connections you want to use. The default of 4 should be appropriate for most people. Setting it too high will hinder the performance. 

`BrowserSig` is the browser you want to **appear** to be using. It's not relevant to the browser you are actually using. Currently, `chrome` and `firefox` are supported.

# ShadowSocks Golang Configuration
[Shadowsocks Manual - Offical Repo.](https://github.com/shadowsocks/go-shadowsocks2/blob/master/README.md)

### Server

Start a server listening on port 8488 using `AEAD_CHACHA20_POLY1305` AEAD cipher with password `your-password`.

```sh
go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose
```


### Client

Start a client connecting to the above server. The client listens on port 1080 for incoming SOCKS5 
connections, and tunnels both UDP and TCP on port 8053 and port 8054 to 8.8.8.8:53 and 8.8.4.4:53 
respectively. 

```sh
go-shadowsocks2 -c 'ss://AEAD_CHACHA20_POLY1305:your-password@[server_address]:8488' \
    -verbose -socks :1080 -u -udptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 \
                             -tcptun :8053=8.8.8.8:53,:8054=8.8.4.4:53
```

Replace `[server_address]` with the server's public address.
