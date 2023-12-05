NS ?= ponte124
VERSION ?= 0.35.0
IMAGE_NAME ?= mqttwarn
CONTAINER_NAME ?= mqttwarn
CONTAINER_INSTANCE ?= manual

build:
	docker build -t $(IMAGE_NAME):$(VERSION) -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

buildx:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 --push -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

push:
	docker push $(NS)/$(IMAGE_NAME):$(VERSION)

shell: 
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

run: 
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

start: 
	docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

stop:
	docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm:
	docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

install:
	kubectl apply -f k8s-mqttwarn-cm.yaml
	kubectl apply -f k8s-mqttwarn-deploy.yaml

uninstall:
	kubectl delete -f k8s-mqttwarn-deploy.yaml
	kubectl delete -f k8s-mqttwarn-cm.yaml

checkupdates:
	docker run --rm --name dium \
	-e "TZ=Europe/Madrid" -e "LOG_LEVEL=info" -e "LOG_JSON=false" -e "DIUN_WATCH_WORKERS=20" -e "DIUN_WATCH_SCHEDULE=0 * * * *" \
	-e "DIUN_PROVIDERS_DOCKER=false" \
  	-v "$(pwd)/data:/data" -v "/var/run/docker.sock:/var/run/docker.sock" -v "${PWD}/diunconfig:/etc/diun:ro" -v "${PWD}:/toanalyze:ro" \
  	-l "diun.enable=true" \
  	crazymax/diun:latest

dockerlint:
	docker run --rm -i ghcr.io/hadolint/hadolint < Dockerfile

dockerscan: build
	# apt-get update && apt-get install docker-scan-plugin
	docker scan --file Dockerfile $(IMAGE_NAME):$(VERSION)

default: run
