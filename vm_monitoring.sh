#!/bin/bash
yes | sudo apt-get update

yes | sudo groupadd --system prometheus
yes | sudo useradd -s /sbin/nologin --system -g prometheus prometheus

yes | sudo mkdir /etc/prometheus
yes | sudo mkdir /var/lib/prometheus

yes | sudo wget https://github.com/prometheus/prometheus/releases/download/v2.50.1/prometheus-2.50.1.linux-amd64.tar.gz
yes | sudo tar vxf prometheus*.tar.gz

cd prometheus*/

yes | sudo mv prometheus /usr/local/bin
yes | sudo mv promtool /usr/local/bin
yes | sudo chown prometheus:prometheus /usr/local/bin/prometheus
yes | sudo chown prometheus:prometheus /usr/local/bin/promtool


yes | sudo cp -r consoles /etc/prometheus
yes | sudo cp -r console_libraries /etc/prometheus


yes | sudo chown prometheus:prometheus /etc/prometheus
yes | sudo chown -R prometheus:prometheus /etc/prometheus/consoles
yes | sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
yes | sudo chown -R prometheus:prometheus /var/lib/prometheus

cd ..

yes | sudo mv prometheus.yml /etc/prometheus
yes | sudo mv daemon.json /etc/docker

sudo cat > prometheus.service <<- "EOF"
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

yes | sudo mv prometheus.service /etc/systemd/system/
yes | sudo chown root:root /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload

sudo systemctl enable prometheus
sudo systemctl start prometheus


sudo apt-get install gnupg2 curl wget git software-properties-common -y
sudo apt install -y apt-transport-https
yes | sudo curl https://packages.grafana.com/gpg.key | apt-key add -
yes | sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

yes | sudo apt-get update
yes | sudo apt-get install grafana

yes | sudo systemctl enable --now grafana-server

yes | sudo systemctl stop grafana-server
yes | sudo grafana-cli admin reset-admin-password ditpass
yes | sudo systemctl start grafana-server

yes | sudo apt-get --reinstall install grafana

sudo systemctl restart docker
yes | sudo docker-compose up -d