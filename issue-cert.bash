#!/bin/bash
[ ! -d "/root/.acme.sh/rpc.${DOMAIN_NAME}" ] && ~/.acme.sh/acme.sh --issue --standalone \
  -d blockscout.${DOMAIN_NAME} \
  -d rpc.${DOMAIN_NAME} \
  -d explorer.${DOMAIN_NAME} \
  -d staking.${DOMAIN_NAME} \
  -d faucet.${DOMAIN_NAME} || true