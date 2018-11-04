#!/bin/bash

if ! [ "${CHANNEL}" ]
then
  CHANNEL=private
fi

slack () {
  curl -X POST -H "Content-type: application/json" --data "{\"text\": \"$1\", \"channel\": \"#${CHANNEL}\", \"link_names\": 1, \"username\": \"Aria2\", \"icon_emoji\": \":monkey_face:\"}" ${SLACK}
} 

if [ "${SLACK}" ]
then
slack "The files have downloaded, but no upload.\n$3"
fi
