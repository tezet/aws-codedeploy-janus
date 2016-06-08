#!/usr/bin/env bash

PREFIX=/usr

#!/bin/bash
app_pid = `pgrep janus`
if [[ -n  $app_pid ]]; then
    kill $app_pid
fi
