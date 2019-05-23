.PHONY: proto

proto:
	protoc -I. --go_out=plugins=micro:. proto/consignment.proto

build: proto
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o bin/consignment .
	docker build -t consignment-svc .

run:
	docker run \
		-p 50051:50051 \
		-e MICRO_SERVER_ADDRESS=:50051 \
		-e MICRO_REGISTRY=mdns \
		consignment-svc