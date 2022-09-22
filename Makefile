.PHONY: check-env
check-env:
ifndef DOMAIN_NAME
	$(warning env DOMAIN_NAME is undefined)
endif
ifndef CHAIN_ID
	$(error env CHAIN_ID is undefined)
endif

.PHONY: install-docker
install-docker:
	bash ./scripts/install-docker.bash

.PHONY: install-acme
install-acme:
	curl https://get.acme.sh | sh -s email=dmitry@ankr.com || true
	bash ./scripts/issue-cert.bash

.PHONY: create-genesis
create-genesis: check-env
	docker build -t bas-genesis-config ./genesis
	rm -rf ./genesis.json
	envsubst < config.json > tmp_config.json
	docker run --rm -v ${PWD}/tmp_config.json:/config.json -t bas-genesis-config /config.json > ./genesis.json
	rm -f tmp_config.json

.PHONY: start
start: check-env
	cat ./docker-compose.yaml | envsubst | docker-compose -f - pull
	cat ./docker-compose.yaml | envsubst | docker-compose -f - up -d

.PHONY: stop
stop:
	docker compose stop

.PHONE: reset-explorer
reset-explorer: check-env stop
	docker compose stop
	rm -rf ./datadir/blockscout
	cat ./docker-compose.yaml | envsubst | docker-compose -f - up -d

.PHONE: reset
reset: stop
	rm -rf ./datadir

.PHONY: all
all: create-genesis start