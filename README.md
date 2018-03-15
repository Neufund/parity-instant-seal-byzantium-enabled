# Parity with instantSeal engine and byzantium EIPs enabled

This is parity instantSeal byzantium enabled development mode

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Installing

Clone repository and build docker container
```
docker-compose -p eth_parity_dev_node -f docker-compose.yml up --build -d
```
In case of linux run
```
sudo docker-compose -p eth_parity_dev_node -f docker-compose.yml up --build -d
```
### Parity version

We clone and build `1.8.7` neufund mod (additional eth_getLogDetails RPC command)

## Connecting to node

To connect to web interface of the node

```
http://127.0.0.1:8180/
```
For the first generation of authentication token you need to issue command
```
parity signer new-token
```
And make sure that authtokens file is in /var/parity/signer (it's a volume)

### Deployment with Truffle

Parity will not work with Truffle. Truffle expects null returned as receipt when transaction is still pending, parity returns normal receipt but with blockHash == null. You can force this behavior (so called `geth` mode) by executing (mind trailing `--geth --force-ui` flags)

When deploying it's good idea to unlock your account. Command line was provided in `supervisord.conf` (default one) unlocks 8 predefined accounts. Unlocked account must have `test` password. If not change password file.

### Byzantium and pre-byzantium error handling for calls and transaction

**Calling constant method that reverts**
* pre-byzantium and post byzantium parity will return `result: 0x` (0x in result field of JSON-RPC response). Clearly it does not look as the error code ;> and if you are using web3, it will try to decode and fail specific expection per expected data type returned (like invalid BigNumber or address), some types will just succeed so **BEWARE**
* `testrpc` will return exception string `invalid opcode` and stack trace in `error` field of JSON-RPC response

**Executing transactions that revert**
* pre-byzantium parity - normal transaction object and transaction receipt are returned (just with all gas used). there is no other way to detect revert besides generating and checking events in case of success (so lack of event is error situation). this is very weak
* post-byzantium parity and other nodes - there is `status` field in transaction receipt! use this. use Neufund modified truffle that recognize this situation (https://github.com/Neufund/truffle), `neufund` branch.
* `testrpc` will return exception string `invalid opcode` and stack trace in `error` field of JSON-RPC response
