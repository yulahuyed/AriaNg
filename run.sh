#!/bin/bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < passwd_template > /tmp/passwd
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export PATH=$HOME/aria2:$PATH
export RCLONE_CONFIG=$HOME/config/rclone.conf


cat << EOF >> ~/.profile
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export PATH=$HOME/aria2:$PATH
export RCLONE_CONFIG=$HOME/config/rclone.conf
EOF

cat << EOF >> ~/.bashrc
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export PATH=$HOME/aria2:$PATH
export RCLONE_CONFIG=$HOME/config/rclone.conf
EOF


if [ "$extend_script" ] && [ ! -f "$HOME/config/extend.sh" ]
then
curl -L -o $HOME/config/extend.sh "$extend_script"
source $HOME/config/extend.sh
fi


if [ "${RCONFIG}" ] && [ ! -f "$RCLONE_CONFIG" ]
then
  curl -L -o $RCLONE_CONFIG "${RCONFIG}"
fi

if [ "${URL}" ]
then
  sed -i "s/localhost/${URL}/g" $HOME/aria2/js/aria-ng-*.min.js
  sed -i "s/6800/80/g" $HOME/aria2/js/aria-ng-*.min.js
fi

mkdir /tmp/Downloads
touch aria2.session
touch /tmp/dht.dat
nohup ./gotty -p 7900 -w bash -c "${GOTTY_USER}:${GOTTY_PASS}" >/dev/null 2>&1 &

nohup ./aria2c --conf-path=aria2.conf >/dev/null 2>&1 &

./caddy -conf Caddyfile
