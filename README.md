BAS DevNet Setup
===============

This repository contains scripts for running an independent instance of BAS.

Before running command you must do following steps:
- Buy a dedicated machine that have at least 8 dedicated CPU core and 32GB RAM (it runs 7 nodes)
- Make sure you have wildcard domain `*.example.com` set to your machine (use dedicated machine with public IP)
- Modify `config.json` file to update parameters you need (you can find all addresses in keystore folder)

Config structure:
- `chainId` - identifier of your BAS chain
- `validators` - list of initial validator set (make sure that you have the same list in docker compose file)
- `systemTreasury` - address of system treasury that accumulates 1/16 of rewards (might be governance)
- `consensusParams` - parameters for the consensus and staking
  - `activeValidatorsLength` - suggested values are (3k+1, where k is honest validators, even better): 7, 13, 19, 25, 31...
  - `epochBlockInterval` - better to use 1 day epoch (86400/3=28800, where 3s is block time)
  - `misdemeanorThreshold` - after missing this amount of blocks per day validator losses all daily rewards (penalty)
  - `felonyThreshold` - after missing this amount of blocks per day validator goes in jail for N epochs
  - `validatorJailEpochLength` - how many epochs validator should stay in jail (7 epochs = ~7 days)
  - `undelegatePeriod` - allow claiming funds only after 6 epochs (~7 days)
  - `minValidatorStakeAmount` - how many tokens validator must stake to create a validator (in ether)
  - `minStakingAmount` - minimum staking amount for delegators (in ether)
- `initialStakes` - initial stakes fot the validators (must match with validators list)
- `votingPeriod` - default voting period for the governance proposals
- `faucet` - map with initial balances for faucet and other needs

You can check Makefile to choose the most interesting commands, but if you just need to set up everything just run next command:

```bash
apt update
apt install -y build-essential socat
git clone https://github.com/Ankr-network/bas-devnet-setup bas --recursive
cd bas
CHAIN_ID=14000 DOMAIN_NAME=dev-02.bas.ankr.com make all
```

P.S: Variable `DOMAIN_NAME` should be set to your domain

Deployed services can be access though next endpoints:
- https://rpc.${DOMAIN_NAME} (port 8545,8546) - Web3 RPC endpoint
- https://explorer.${DOMAIN_NAME} (port 4000) - Blockchain Explorer
- https://faucet.${DOMAIN_NAME} (port 3000) - Faucet
- https://staking.${DOMAIN_NAME} (port 3001) - Staking UI

If you want to run node w/o load balancer and SSL certificates then use next command:
```bash
make all-no-balancer
```

Docker compose files exposes next ports:
- 7432 - blockscout PostgreSQL database
- 4000 - blockscout explorer
- 3000 - faucet UI
- 3001 - staking UI
- 8545 - RPC endpoint
- 8546 - WS endpoint
- 30303 - bootnode