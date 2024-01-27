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



influx \
  config \
  create \
  --config-name config1 \
  --active \
  --host-url http://10.0.4.11:8086 \
  --org org1 \
  --token txMSSv0iAasvZr84cq28ffGWX5oFPL-ZRXRYLPrmFia8weZUEWldQsp8mmxj8cj64VfILNABp6OR7azI3b83Ug==

influx remote create \
  --json \
  --name remote_for_temp \
  --remote-url http://10.0.4.11:8086 \
  --remote-api-token txMSSv0iAasvZr84cq28ffGWX5oFPL-ZRXRYLPrmFia8weZUEWldQsp8mmxj8cj64VfILNABp6OR7azI3b83Ug== \
  --remote-org-id 928fc05750efd5a3

influx replication create \
  --json \
  --name replication_for_temp \
  --remote-id 0c7e3c4dc99ad000 \
  --local-bucket-id d66cb645e6987545 \
  --remote-bucket industry_security_t_alpha
