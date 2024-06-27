# Use Ubuntu as the base image
FROM ubuntu:20.04

# Install wget and gettext for envsubst
RUN apt-get update && apt-get install -y wget gettext

# Set Prometheus version
ENV PROMETHEUS_VERSION=2.7.1

# Download and extract Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/ && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/ && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles /etc/prometheus/ && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries /etc/prometheus/ && \
    rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz prometheus-${PROMETHEUS_VERSION}.linux-amd64

# Copy Prometheus configuration file
COPY ../../prometheus/prometheus.yml /etc/prometheus/prometheus.yml

# Expose Prometheus port
EXPOSE 9090

# Entry point to replace environment variables and start Prometheus
ENTRYPOINT ["/bin/sh", "-c", "envsubst < /etc/prometheus/prometheus.yml > /tmp/prometheus.yml && prometheus --config.file=/tmp/prometheus.yml --storage.tsdb.path=/prometheus --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles"]
