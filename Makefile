NAME=chisel
AUTHOR ?= ukhomeofficedigital
REGISTRY ?= quay.io
VERSION ?= latest

.PHONY: build test

default: build

build:
	@echo "--> Builing the docker image: ${REGISTRY}/${AUTHOR}/${NAME}:${VERSION}"
	docker build -t ${REGISTRY}/${AUTHOR}/${NAME}:${VERSION} .

push:
	@echo "--> Pushing the image to respository"
	docker push ${REGISTRY}/${AUTHOR}/${NAME}:${VERSION}

clean:
	@echo "--> Performing a cleanup"
	docker rmi -f ${REGISTRY}/${AUTHOR}/${NAME}:${VERSION}

server:
	@echo "--> Running a server"
	docker run -ti --net=host --rm \
		-v ${PWD}/tests:/etc/chisel \
		${REGISTRY}/${AUTHOR}/${NAME}:${VERSION} \
		server \
		--authfile /etc/chisel/users_sample.json \
		--key supersecret \
		--port=9080 \
		-v

client:
	@echo "--> Running a server"
	docker run -ti --net=host --rm \
		-v $(PWD)/tests:/etc/chisel \
		-e AUTH=guest:guest \
		-e CHISEL_KEY=supersecret \
		${REGISTRY}/${AUTHOR}/${NAME}:${VERSION} \
		client \
		127.0.0.1:9080 \
		:10080:google.co.uk:80 \
		:10443:google.co.uk:443
