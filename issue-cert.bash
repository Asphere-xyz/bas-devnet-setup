#!/bin/bash
~/.acme.sh/acme.sh --issue --standalone \
  -d rpc.${DOMAIN_NAME} \
  -d explorer.${DOMAIN_NAME} \
  -d staking.${DOMAIN_NAME} \
  -d faucet.${DOMAIN_NAME}