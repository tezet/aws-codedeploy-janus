#!/usr/bin/env bash

PREFIX=/usr

app_pid=`pgrep janus`
while [[ -n  $(pgrep janus) ]]; do
    kill $app_pid
    sleep 1
done

$PREFIX/share/janus/scripts/janus.cfg.sh
$PREFIX/bin/janus -b -L /var/log/janus.log
