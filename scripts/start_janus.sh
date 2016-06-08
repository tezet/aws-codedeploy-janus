#!/usr/bin/env bash

PREFIX=/usr

$PREFIX/share/janus/scripts/janus.cfg.sh
$PREFIX/bin/janus -b -L /var/log/janus.log
