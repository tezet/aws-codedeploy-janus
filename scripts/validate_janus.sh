#!/usr/bin/env bash

if [[ -n  $(pgrep janus) ]]; then
    exit 0
else
	exit 1
fi
