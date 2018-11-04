FROM ubuntu:latest

MAINTAINER yhiblog <shui.azurewebsites.net>

ENV GOTTY_USER "yhiblog"
ENV GOTTY_PASS "yhiblog"
ENV SSHPASS "yhiblog"
ENV HOME "/home/user"
ENV RCLONE_CONFIG=$HOME/config/rclone.conf


RUN apt update && apt install -y bash vim screen net-tools \
curl software-properties-common libnss-wrapper gettext-base unzip wget \
python ffmpeg sudo

RUN mkdir -p $HOME/config


WORKDIR $HOME

RUN curl -o aria2.tar.gz -L "https://github.com/king567/Aria2-static-build-128-thread/releases/download/v1.34.0/aria2-v1.34.0-static-build-128-thread.tar.gz"
RUN tar xzf aria2.tar.gz
RUN mv aria2-* aria2
RUN rm -f aria2.tar.gz

ENV PATH=$HOME/aria2:$PATH

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

RUN curl -o gotty.tar.gz -L https://github.com/yudai/gotty/releases/download/v2.0.0-alpha.3/gotty_2.0.0-alpha.3_linux_amd64.tar.gz
RUN tar xzf gotty.tar.gz
RUN rm -f gotty.tar.gz

RUN adduser --uid 1000 --gid 0 --disabled-password --gecos "" --no-create-home --shell /bin/bash user
RUN echo "user:$SSHPASS" | chpasswd
RUN echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/user
RUN echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers.d/user
RUN apt-get clean all

ADD . $HOME/aria2/

RUN mv gotty.js hterm.js gotty-bundle.js $HOME/aria2/js
RUN mv xterm_customize.css xterm.css index.css $HOME/aria2/css

RUN chmod -R 777 /home

USER 1000

EXPOSE 8080

CMD ["/home/user/aria2/run.sh"]
