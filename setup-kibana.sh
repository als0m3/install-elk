#!/bin/bash

# Installing Kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.12.2-amd64.deb
sudo dpkg -i kibana-8.12.2-amd64.deb

# Configure Kibana
content=$(cat <<EOF
# ======================== Kibana Configuration =========================
# DATE ${kibana_creation_date}

# ---------------------------------- Server -----------------------------------
server.host: 0.0.0.0
server.port: 5601


# ------------------------------- Elasticsearch --------------------------------
elasticsearch.hosts: ${elk_var_elasticsearch_hosts}

elasticsearch.username: "kibana_system"
elasticsearch.password: ""

elasticsearch.ssl:
  certificateAuthorities: ["/etc/kibana/certs/ca.crt"]
  verificationMode: certificate
  certificate: /etc/kibana/certs/node.crt
  key: /etc/kibana/certs/node.key

server.ssl:
    enabled: true
    certificate: /etc/kibana/certs/node.crt
    key: /etc/kibana/certs/node.key


EOF
)

echo "${content}" > /etc/kibana/kibana.yml

sudo mkdir /etc/kibana/certs
sudo mv /ca.crt /etc/kibana/certs/ca.crt
sudo mv /node.crt /etc/kibana/certs/node.crt
sudo mv /node.key /etc/kibana/certs/node.key


# Start Kibana
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

sudo /bin/systemctl start kibana.service