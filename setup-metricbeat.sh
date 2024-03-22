#!/bin/bash

# Installing Metricbeat
wget --quiet https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.12.2-amd64.deb
sudo dpkg -i metricbeat-8.12.2-amd64.deb

metricbeat modules enable elasticsearch-xpack

# Configure Metricbeat
content=$(cat <<EOF
# ======================== Metricbeat Configuration =========================
# DATE ${es_creation_date}

# ---------------------------- Config Reloading -------------------------------
metricbeat.config.modules:
  path: ${path.config}/modules.d/*.yml

  reload.enabled: false

# --------------------------- Elasticsearch Module ----------------------------
setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression

# ------------------------------ Kibana Output --------------------------------
setup.kibana:

# ---------------------------- Elasticsearch Output ----------------------------
output.elasticsearch:
  hosts: ["0.0.0.0:9200"]
  preset: balanced

# ------------------------------ Logstash Output -------------------------------
processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
EOF
)

echo "${content}" > /etc/metricbeat/metricbeat.yml

# Start Metricbeat
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable metricbeat.service

sudo /bin/systemctl start metricbeat.service