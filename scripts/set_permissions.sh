#!/usr/bin/env bash

PREFIX=/usr
LOG_FILE=/var/log/janus.log
JANUS_USER=janus
JANUS_GROUP=janus
CONFIG_DIR=$PREFIX/etc/janus
SHARE_DIR=$PREFIX/share/janus

# Create user if does not exist
if ! id -u $JANUS_USER > /dev/null 2>&1; then
    echo "Creating user" $JANUS_USER
    useradd -r $JANUS_USER
fi

echo "Changing permissions"
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
