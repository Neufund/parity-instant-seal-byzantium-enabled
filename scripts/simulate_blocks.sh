#!/usr/bin/env bash

if [[ "$SIMULATE_BLOCKS" != true ]] ; then
    echo "SIMULATE_BLOCK env variable not true - exiting"
    exit 1
fi

while [ 1 ]
    do
    echo "`date` Sending transaction to simulate new block"

    OUTPUT=$(curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x04BEfE8ab2aB7Ce71C610A5daE0cbF826b6C4F7a", "to": "0x04BEfE8ab2aB7Ce71C610A5daE0cbF826b6C4F7a", "gas": "0x55F0", "gasPrice": "0x989680", "value": "0x00", "data": "0x00"}],"id":1}' http://localhost:8545)
    if [[ ${OUTPUT} != *"result"* ]] ; then
      echo "Transaction didn't pass see output: $OUTPUT"
      exit 1
    fi
    sleep 10
done
