#!/bin/bash

# Installing Elasticsearch
wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.12.2-amd64.deb
wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.12.2-amd64.deb.sha512
shasum -a 512 -c elasticsearch-8.12.2-amd64.deb.sha512 
sudo dpkg -i elasticsearch-8.12.2-amd64.deb


# Configure Elasticsearch
echo '' > /etc/elasticsearch/elasticsearch.yml
cat <<'EOF' >>/etc/elasticsearch/elasticsearch.yml
--- Cluster
cluster.name: ${es_cluster_name}

--- Nodes
node.name: ${es_data_node_name}
node.roles: [ master, data ]


--- Paths
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch


--- Network
network.host: 0.0.0.0
http.port: 9200


--- Discovery
discovery.seed_hosts: ${es_seed_hosts}


--- Security
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl:
    enabled: false
xpack.security.transport.ssl:
    enabled: false

cluster.initial_master_nodes: ${initial_master_nodes}
EOF


# Start Elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service
