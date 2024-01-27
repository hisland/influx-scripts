#!/bin/bash

influx \
  config \
  create \
  --config-name config1 \
  --active \
  --host-url http://dd.llmcxt.com:9025 \
  --org org1 \
  --token _bd_9ZNaF7pPPgLFVUaYXfnBAmxjGmnotjqdYXZ2cpskNJfgyWRV3LQUipLOk7ZcuW2-P-m2ak1ehlvXtaovpQ==

influx remote create \
  --json \
  --name remote1 \
  --remote-url http://dd.llmcxt.com:9025 \
  --remote-api-token _bd_9ZNaF7pPPgLFVUaYXfnBAmxjGmnotjqdYXZ2cpskNJfgyWRV3LQUipLOk7ZcuW2-P-m2ak1ehlvXtaovpQ== \
  --remote-org-id 1f6f1f031273fcaa

influx replication create \
  --json \
  --name replication1 \
  --remote-id 0c7d2f3ca89db000 \
  --local-bucket-id 9c339a51ba7a9ef7 \
  --remote-bucket bk3
