#!/bin/sh

wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz
mv node_exporter-1.5.0.linux-amd64 /opt/node_exporter
wget https://github.com/TheRealArtyom/cloud-configs/blob/main/services/node_exporter.service -O /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service
