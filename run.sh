#!/bin/sh

nohup ./caddy -conf Caddyfile >/dev/null 2>&1 &
nohup ./aria2c --conf-path=aria2.conf >/dev/null 2>&1 &
