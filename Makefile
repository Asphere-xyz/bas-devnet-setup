.PHONY: install-docker
install-docker:
	bash ./install-docker.bash

.PHONY: install-acme
install-acme:
	apt update && apt install socat
	curl https://get.acme.sh | sh -s email=dmitry@ankr.com

.PHONY: create-genesis
create-genesis:
	docker build -t bas-genesis-config ./genesis
	docker run --rm -v ${PWD}/config.json:/config.json -t bas-genesis-config /config.json > ./genesis.json

.PHONY: run-blockchain
run-blockchain:
	docker compose up --build -d

.PHONY: run-explorer
run-explorer:
	docker compose -f ./blockscout/docker-compose.yaml up --build -d

.PHONY: all
all: install-docker install-acme create-genesis run-blockchain run-explorer
