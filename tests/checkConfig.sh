#!/bin/bash

docker exec ptx_prometheus promtool check config /etc/prometheus/prometheus.yml
