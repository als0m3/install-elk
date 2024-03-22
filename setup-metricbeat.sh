#!bin/bash

# Installing Metricbeat
wget --quiet https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.12.2-amd64.deb
sudo dpkg -i metricbeat-8.12.2-amd64.deb

metricbeat modules enable elasticsearch-xpack

# Configure Metricbeat
content=$(cat <<EOF
###################### Metricbeat Configuration Example #######################

# =========================== Modules configuration ============================

metricbeat.config.modules:
  path: ${path.config}/modules.d/*.yml

  reload.enabled: false

# ======================= Elasticsearch template setting =======================

setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression


# ================================== General ===================================

# ================================= Dashboards =================================

# =================================== Kibana ===================================
setup.kibana:

# =============================== Elastic Cloud ================================

# ================================== Outputs ===================================

# ---------------------------- Elasticsearch Output ----------------------------
output.elasticsearch:
  hosts: ["0.0.0.0:9200"]
  preset: balanced

# ------------------------------ Logstash Output -------------------------------
# ================================= Processors =================================
processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~

# ================================== Logging ===================================
# ============================= X-Pack Monitoring ==============================
# ============================== Instrumentation ===============================
# ================================= Migration ==================================
EOF
)

echo "${content}" > /etc/metricbeat/metricbeat.yml

# Start Metricbeat
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable metricbeat.service

sudo systemctl start metricbeat.service