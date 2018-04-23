help:
	@echo "container - builds parity container"
	@echo "run - runs node"
	@echo "donw - bring node down"

container:
	docker build . -t neufund/parity-instant-seal-byzantium-enabled

run: container
	docker-compose -p eth_parity_dev_node -f docker-compose.yml up --build -d

down:
	docker-compose -p eth_parity_dev_node -f docker-compose.yml down
