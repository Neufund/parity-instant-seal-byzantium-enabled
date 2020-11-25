help:
	@echo "container - builds parity container"
	@echo "run - runs node"
	@echo "donw - bring node down"

container:
	docker build . -t neufund/parity-instant-seal-byzantium-enabled

run: container
	docker-compose -p eth_openethereum_dev_node -f docker-compose.yml up --build -d

down:
	docker-compose -p eth_openethereum_dev_node -f docker-compose.yml down

simulate-blocks:
	docker-compose -p eth_openethereum_dev_node -f docker-compose.yml exec -d -T eth_openethereum_dev_node sh -c "SIMULATE_BLOCKS=true BLOCKS_FREQ=1 /var/openethereum/simulate_blocks.sh"
