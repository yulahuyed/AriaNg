FROM ubuntu:latest

MAINTAINER yhiblog <shui.azurewebsites.net>

ENV GOTTY_USER "yhiblog"
ENV GOTTY_PASS "yhiblog"
ENV HOME "/home/user/"
ENV RCLONE_CONFIG=$HOME/config/rclone.conf

RUN apt update && apt install -y bash vim screen net-tools \
curl software-properties-common libnss-wrapper gettext-base unzip wget \
python-software-properties python

RUN add-apt-repository ppa:jonathonf/ffmpeg-3

RUN apt-get update && apt-get install ffmpeg libav-tools x264 x265

RUN mkdir -p $HOME/aria2 && mkdir -p $HOME/config

WORKDIR $HOME/aria2

RUN curl -o rclone.zip -L `curl -L https://rclone.org/downloads/ | grep -E ".*linux.*amd64.zip" | head -n 1 | awk -F "href" '{print $2}' | awk -F '"' '{print $2}'`
RUN unzip rclone.zip
RUN mv ./rclone*/rclone $HOME/aria2/
RUN rm -rf rclone.zip rclone-*

RUN curl -L -o caddy.tar.gz "https://caddyserver.com/download/linux/amd64?plugins=http.filemanager&license=personal&telemetry=off"
RUN tar -xzf caddy.tar.gz
RUN rm -rf caddy.tar.gz

RUN curl -o AriaNg.zip -L "https://github.com/mayswind/AriaNg/releases/download/0.5.0/AriaNg-0.5.0.zip"
RUN unzip AriaNg.zip
RUN rm -f AriaNg.zip

RUN curl -o gotty.tar.gz -L  https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz
RUN tar xzf gotty.tar.gz
RUN rm -f gotty.tar.gz

ADD . $HOME/aria2/

RUN mv gotty.js hterm.js $HOME/aria2/js

RUN chmod -R 777 /home

CMD ["$HOME/aria2/run.sh"]
