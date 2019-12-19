FROM ubuntu:19.04

ENV SHADOWSOCKS_VERSION 1.2.1
ENV CLOAK_VERSION 2.1.2

ENV SERVER_ADDR  0.0.0.0
ENV SERVER_PORT  12345
ENV PASSWORD=
ENV METHOD       chacha20

COPY bin/ck-server-linux-amd64-${CLOAK_VERSION} /opt/ck-server
COPY bin/shadowsocks-server-${SHADOWSOCKS_VERSION} /opt/ss-server
COPY config/server.conf /opt/server.conf
WORKDIR /opt

RUN chmod +x ck-server
RUN chmod +x ss-server

EXPOSE 80 443
CMD exec ./ss-server \
      -p $SERVER_PORT \
      -k ${PASSWORD:-$(hostname)} \
      -m $METHOD & \
      exec ./ck-server -c server.conf
