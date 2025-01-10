#!/bin/bash

docker exec ptx_prometheus promtool test rules /etc/prometheus/test.yml
