FROM shadowsocks/shadowsocks-libev:v3.3.3

ENV SERVER_ADDR  0.0.0.0
ENV SERVER_PORT  12345
ENV PASSWORD=
ENV METHOD       aes-256-gcm
ENV TIMEOUT      300
ENV DNS_ADDRS    8.8.8.8,1.1.1.1
ENV ARGS=

COPY bin/ck-server-linux-amd64-2.1.2 /opt/ck-server
COPY config/server.conf /opt/server.conf
RUN chmod +x /opt/ck-server
EXPOSE 80 443
CMD exec exec ss-server \
      -s $SERVER_ADDR \
      -p $SERVER_PORT \
      -k ${PASSWORD:-$(hostname)} \
      -m $METHOD \
      -t $TIMEOUT \
      -d $DNS_ADDRS \
      -u \
      $ARGS & \
      /opt/ck-server -c /opt/server.conf
