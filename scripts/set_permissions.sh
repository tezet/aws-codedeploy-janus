#!/usr/bin/env bash

PREFIX=/usr
LOG_FILE=/var/log/janus.log
JANUS_USER=ubuntu
JANUS_GROUP=ubuntu
CONFIG_DIR=$PREFIX/etc/janus
SHARE_DIR=$PREFIX/share/janus

if [ ! -d $CONFIG_DIR ]; then
  mkdir -p $CONFIG_DIR
fi
chown -R $JANUS_USER:$JANUS_GROUP $CONFIG_DIR

if [ ! -d $SHARE_DIR ]; then
  mkdir -p $SHARE_DIR
fi
chown -R $JANUS_USER:$JANUS_GROUP $SHARE_DIR

if [ ! -f $LOG_FILE ]; then
    touch $LOG_FILE
fi
chown $JANUS_USER:$JANUS_GROUP $LOG_FILE
