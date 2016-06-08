#!/usr/bin/env bash

PREFIX=/usr

#generate certificate
mkdir -p $PREFIX/share/janus/certs && \
openssl req \
-new \
-newkey rsa:4096 \
-days 365 \
-nodes \
-x509 \
-subj "/C=AU/ST=NSW/L=Cracow/O=Idilia/CN=idilia.commandcentral.com" \
-keyout $PREFIX/share/janus/certs/janus.key \
-out $PREFIX/share/janus/certs/janus.pem
