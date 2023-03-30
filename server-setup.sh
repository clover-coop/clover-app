#!/bin/bash

SERVER_IP=[ip]
GITHUB_TOKEN=[token]


cd /var && mkdir www && cd /var/www && \
    # Install python3 and pip3
    apt-get -y update && apt-get -y upgrade && python3 -V && apt -y install python3-pip && \
    # Clone repo
git clone https://$GITHUB_TOKEN@github.com/clover-coop/clover-app.git && \
    cd clover-app

# Update configs and copy prod version to server.
    # `config.yml` - e.g. set port to 443 (for SSL), enable SSL, add paths to SSL cert files.
    # `config-loggly.conf`
    # `frontend/.env`

    # Note: Flutter may fail to install (gets corrupted) without >1 GB RAM.
apt-get -y install libssl-dev && \
    pip3 install -r ./requirements.txt && \
    snap install flutter --classic && \
    flutter channel beta && flutter upgrade && flutter config --enable-web && \
    cd frontend && flutter build web && cd ../ && \
    cp systemd_web_server_clover_app.service /etc/systemd/system/systemd_web_server_clover_app.service && \
    systemctl daemon-reload && \
    systemctl enable systemd_web_server_clover_app.service && \
    systemctl restart systemd_web_server_clover_app.service

# Add SSL cert. https://certbot.eff.org/instructions
