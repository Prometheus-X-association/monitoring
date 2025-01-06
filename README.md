# Monitoring

## Overview

This project implements a monitoring stack using Prometheus,Grafana, Loki, and other components to provide observability forapplications and services. It allows users to collect metrics,visualize data, and set up alerts for system performance and health.

## Installation Instructions

1. Clone the repository:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Copy the sample environment file and configure your environment variables:

    ```bash
    cp .env.sample .env
    ```

3. Ensure Docker and Docker Compose are installed on your machine.

## Configuration

- **Prometheus Configuration**: Located in `prometheus/prometheus.yml`, this file defines the scrape intervals and targets for metrics collection.
- **Grafana Dashboards**: The dashboards are defined in JSON files located in `grafana/dashboards/`. You can customize these to fit your monitoring needs.

## Start & Stop

```bash
# Start
docker-compose up -d

# Stop
docker-compose down
```

<p align="center"><img src="_pics/prometheus_loki.png" alt="Grafana splitted dashboard: prometheus with loki" width="700"></p>

## Running Tests

To ensure that your monitoring stack is configured correctly, you can run the following tests:

1. **Check Prometheus Configuration**:
    ```bash
    ./tests/checkConfig.sh
    ```
    **Expected Output**:
    ```
    Checking config file /etc/prometheus/prometheus.yml: SUCCESS
    ```

2. **Health Check for Containers**:
    ```bash
    ./tests/healthCheck.sh
    ```
    **Expected Output**:
    ```
    ptx_prometheus: running
    ptx_grafana: running
    ptx_loki: running
    ```

3. **Test Prometheus Rules**:
    ```bash
    ./tests/testRules.sh
    ```
    **Expected Output**:
    ```
    Testing rules file /etc/prometheus/test.yml: SUCCESS
    ```
    *Note: The `test.yml` file contains examples for tests and rules. More can be added and customized as needed.*

## Components

This playground contains:

- `loki` - storage for logs
- `promtail` that scrapes logs from your `/var/log` directory and puts to `loki`
- `cadvisor` - exports metrics of running docker containers
- `prometheus` - storage for metrics, get metrics from `cadvisor`, interface: [http://localhost:9090](http://localhost:9090) (by default).
- `grafana`: with pre-configured both datasources — `loki` and `prometheus`. Sample dashboard for node.js app. interface: [http://localhost:3000](http://localhost:3000) (by default).

See [initial specifications here](./docs/design-document.md), [Deployment and implementation specification here](./docs/design-document.md#configuration-and-deployment-settings) and [Further information here](./docs/further-informations.md)
