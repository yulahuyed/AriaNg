#!/bin/bash

if [ "$extend_script" ] && [ ! -f "$HOME/config/extend.sh" ]
then
curl -L -o $HOME/config/extend.sh "$extend_script"
source $HOME/config/extend.sh
fi


if [ "${RCONFIG}" ] && [ ! -f "$RCLONE_CONFIG" ]
then
  curl -L -o $RCLONE_CONFIG "${RCONFIG}"
fi

mkdir /tmp/Downloads
touch aria2.session
touch /tmp/dht.dat
nohup ./gotty -p 7900 -w bash >/dev/null 2>&1 &

nohup ./aria2c --conf-path=aria2.conf >/dev/null 2>&1 &

./caddy -conf Caddyfile
