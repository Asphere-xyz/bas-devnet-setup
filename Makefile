.PHONY: install-docker
install-docker:
	bash ./install-docker.bash

.PHONY: install-acme
install-acme:
	curl https://get.acme.sh | sh -s email=dmitry@ankr.com || true
	bash ./issue-cert.bash

.PHONY: create-genesis
create-genesis:
	docker build -t bas-genesis-config ./genesis
	rm -rf ./genesis.json
	envsubst < config.json > tmp_config.json
	docker run --rm -v ${PWD}/tmp_config.json:/config.json -t bas-genesis-config /config.json > ./genesis.json
	rm -f tmp_config.json

.PHONY: run-blockchain
run-blockchain:
	cat ./docker-compose.yaml | envsubst | docker-compose -f - up -d

.PHONY: run-explorer
run-explorer:
	docker compose -f ./blockscout/docker-compose.yaml up --build -d

.PHONY: run-balancer
run-balancer:
	cat ./balancer/docker-compose.yaml | envsubst | docker-compose -f - up -d

.PHONY: all-no-balancer
all-no-balancer: install-docker create-genesis run-blockchain run-explorer

.PHONY: all
all: install-docker install-acme create-genesis run-blockchain run-explorer run-balancer

.PHONY: stop-all
stop-all:
	docker compose -f ./balancer/docker-compose.yaml stop
	docker compose -f ./blockscout/docker-compose.yaml stop
	docker compose stop

.PHONE: reset-all
reset-all: stop-all
	rm -rf ./datadir ./blockscout/postgres-data