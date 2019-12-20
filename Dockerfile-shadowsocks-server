FROM golang:alpine AS build

WORKDIR /opt
# Install Prerequisites
RUN apk add git make

# Clone Repo
RUN go get -u -v github.com/shadowsocks/go-shadowsocks2

# Final Docker image 
FROM alpine:latest

RUN apk upgrade \
    && apk add tzdata \
    && rm -rf /var/cache/apk/*

ENV SERVER_IP     0.0.0.0
ENV SERVER_PORT   12345
ENV ENCRYPTION    AES-256-CFB
ENV PASSWORD      password

WORKDIR /app
COPY --from=build /go/bin/go-shadowsocks2 /app/shadowsocks-server
COPY scripts/entrypoint-shadowsocks-server.sh /app/entrypoint.sh
RUN chmod +x shadowsocks-server
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]