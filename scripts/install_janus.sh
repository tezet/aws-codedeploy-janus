#!/usr/bin/env bash

apt-get update
apt-get install -y wget

# Download packages to /tmp and install them
mkdir -p /tmp/pkg/
wget -O  /tmp/pkg/usrsctp_latest_amd64.deb       http://archive.idilia.krkcommandcentral.com/usrsctp/usrsctp_latest_amd64.deb
wget -O  /tmp/pkg/janus-gateway_latest_amd64.deb http://archive.idilia.krkcommandcentral.com/janus/janus-gateway_latest_amd64.deb
apt-get install -y /tmp/pkg/usrsctp_latest_amd64.deb /tmp/pkg/janus-gateway_latest_amd64.deb
rm -rf /tmp/pkg
