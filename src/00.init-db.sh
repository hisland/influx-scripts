#!/bin/bash

influx setup \
  --host http://localhost:9024 \
  --name elconfig \
  --username eli \
  --password test1234 \
  --org el \
  --bucket industry_security_t_alpha \
  --force