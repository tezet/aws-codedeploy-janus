#!/usr/bin/env bash

PREFIX=/usr

#!/bin/bash
app_pid=`pgrep janus`
echo "Stopping Janus daemon"
while [[ -n  $(pgrep janus) ]]; do
    echo -ne "."
    kill $app_pid
    sleep 1
done
echo "done"
