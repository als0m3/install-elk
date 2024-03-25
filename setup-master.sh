#!/bin/bash

# Installing Elasticsearch
wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.12.2-amd64.deb
sudo dpkg -i elasticsearch-8.12.2-amd64.deb


# Configure Elasticsearch
content=$(cat <<EOF
# ======================== Elasticsearch Configuration =========================
# DATE ${es_creation_date}

# ---------------------------------- Cluster -----------------------------------
cluster.name: ${es_cluster_name}

# ----------------------------------- Nodes ------------------------------------
node.name: ${es_data_node_name}
node.roles: [ master, data, data_cold, data_content, data_hot, data_warm, ingest, ml, remote_cluster_client, transform]


# ----------------------------------- Paths ------------------------------------
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch


# ---------------------------------- Network -----------------------------------
network.host: 0.0.0.0
http.port: 9200


# --------------------------------- Discovery ----------------------------------
discovery.seed_hosts: ${es_seed_hosts}


# ---------------------------------- Security ----------------------------------
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl:
    enabled: false
xpack.security.transport.ssl:
  enabled: true
  verification_mode: certificate
  keystore.path: certs/elastic-certificates.p12
  truststore.path: certs/elastic-certificates.p12

cluster.initial_master_nodes: ${initial_master_nodes}
EOF
)

echo "${content}" > /etc/elasticsearch/elasticsearch.yml

# Start Elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo /bin/systemctl start elasticsearch.service
