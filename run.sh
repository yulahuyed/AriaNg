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
  if echo "${URL}" | grep -qi https
  then
    sed -i "s/6800/443/g" $HOME/aria2/js/aria-ng-*.min.js
    sed -i 's/protocol:"http"/protocol:"https"/' $HOME/aria2/js/aria-ng-*.min.js
  else
    sed -i "s/6800/80/g" $HOME/aria2/js/aria-ng-*.min.js
  fi
  sed -i "s/localhost/$(echo $URL | sed -e 's/http[s]*://g' -e 's#/##g')/g" $HOME/aria2/js/aria-ng-*.min.js
fi

mkdir /tmp/Downloads
touch aria2.session
touch /tmp/dht.dat



nohup ./aria2c --conf-path=aria2.conf >/dev/null 2>&1 &

nohup ./caddy -conf Caddyfile >/dev/null 2>&1 &

if [ "$GOTTY_PASS" ]
then
./gotty --port 7900 -c "${GOTTY_USER}:${GOTTY_PASS}" -w bash
sed -i "s/yhiblog:yhiblog/${GOTTY_USER}:${GOTTY_PASS}/g" auth_token.js
else
./gotty --port 7900 -w bash
sed -i 's/yhiblog:yhiblog//g' auth_token.js
fi
