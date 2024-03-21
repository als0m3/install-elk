#!/bin/bash

# Installing Elasticsearch
wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.12.2-amd64.deb
wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.12.2-amd64.deb.sha512
shasum -a 512 -c elasticsearch-8.12.2-amd64.deb.sha512 
sudo dpkg -i elasticsearch-8.12.2-amd64.deb


# Configure Elasticsearch
content="""
# Custom Elasticsearch Configuration\n
# Date: ${es_creation_date}\n
\n
--- Cluster\n
cluster.name: ${es_cluster_name}\n
\n
--- Nodes\n
node.name: ${es_data_node_name}\n
node.roles: [ master, data ]\n
\n
\n
--- Paths\n
path.data: /var/lib/elasticsearch\n
path.logs: /var/log/elasticsearch\n
\n
\n
--- Network\n
network.host: 0.0.0.0\n
http.port: 9200\n
\n
\n
--- Discovery\n
discovery.seed_hosts: ${es_seed_hosts}\n
\n
\n
--- Security\n
xpack.security.enabled: true\n
xpack.security.enrollment.enabled: true\n
xpack.security.http.ssl:\n
    enabled: false\n
xpack.security.transport.ssl:\n
    enabled: false\n
\n
cluster.initial_master_nodes: ${initial_master_nodes}\n
"""

echo $content >> /etc/elasticsearch/elasticsearch.yml

# Start Elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service
