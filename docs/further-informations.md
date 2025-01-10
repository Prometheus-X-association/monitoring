# Further Information

## Prometheus configuration

You can find the Prometheus configuration in the `prometheus` directory. This configuration is essential for monitoring your applications and services effectively.

```yaml
global:
  scrape_interval:     10s  # Default interval for scraping metrics
  evaluation_interval: 10s  # Default interval for evaluating rules

alerting:
  alertmanagers:
  - static_configs:
    - targets:  # List of alertmanager instances

rule_files:  # Specify rule files for alerting rules

scrape_configs:
  - job_name: 'cadvisor'  # Job for monitoring container metrics
    static_configs:
      - targets: ['cadvisor:8080']  # Target for cAdvisor

  - job_name: 'consent-manager'  # Job for monitoring consent manager
    static_configs:
      - targets: ['${CONSENT_MANAGER}']  # Target from environment variable

  - job_name: 'contract-manager'  # Job for monitoring contract manager
    static_configs:
      - targets: ['${CONTRACT_MANAGER}']  # Target from environment variable

  - job_name: 'catalog'  # Job for monitoring catalog API
    static_configs:
      - targets: ['${CATALOG}']  # Target from environment variable

  - job_name: 'catalog-registry'  # Job for monitoring catalog registry
    static_configs:
      - targets: ['${CATALOG_REGISTRY}']  # Target from environment variable
```

The `scrape_configs` section is preconfigured to scrape monitoring data for the following building blocks:

* **consent-manager**
* **contract-manager**
* **catalog-api**
* **catalog-registry**

The target for each job is configurable inside the `.env` file, allowing for flexibility in different environments.

You can add any custom job inside this configuration by following the structure shown above. Ensure that the job name is unique and that the target is correctly defined.
