# Elasticsearch lab setup

Shell scripts for installing Elasticsearch, Kibana, and Metricbeat **8.12.2** from Debian packages on an amd64 Linux host with systemd.

## Files

| Script | Purpose |
| --- | --- |
| `setup-master.sh` | Install Elasticsearch and write its cluster configuration. |
| `setup-kibana.sh` | Install Kibana and configure its Elasticsearch connection and HTTPS listener. |
| `setup-metricbeat.sh` | Install Metricbeat and enable the Elasticsearch monitoring module. |

## Status: lab scripts requiring configuration

These scripts overwrite files under `/etc`, move certificate files from `/`, and start services. Read and adapt them before execution. They are not an unattended production installer.

The Elasticsearch script expects `es_creation_date`, `es_cluster_name`, `es_data_node_name`, `es_seed_hosts`, and `initial_master_nodes`. Kibana expects `kibana_creation_date` and `elk_var_elasticsearch_hosts`. List-valued settings must use valid YAML syntax. Supply the CA, node certificate, and private key expected by the scripts.

Before deployment, review the pinned Elastic version, configure credentials, restrict network access, enable Elasticsearch HTTP TLS, and replace Metricbeat's placeholder output address with your actual authenticated endpoint. Existing settings do not provide a complete secure deployment.

Syntax-only verification, without installation:

```sh
bash -n setup-master.sh
bash -n setup-kibana.sh
bash -n setup-metricbeat.sh
```

See [SECURITY.md](SECURITY.md) for private vulnerability reports.
