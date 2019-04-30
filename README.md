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

We use `parity_1.9.7_ubuntu_amd64.deb` from parity website.

## Connecting to node

To connect to web interface of the node

```
http://127.0.0.1:8180/
```

We put predefined authcodes into /var/parity/signer so if you connect remotely see `authcodes` file. Also remember to expose 8546 port (web socket), otherwise UI will not log in.

## Simulate new blocks
If you want you can simulate new blocks that will be "mined" automatically even if you won't issue any transactions. To enable this functionality you need to set env variable.
```
export SIMULATE_BLOCKS=true
```
Script simulates new transactions by regularly sending 0eth transfer from one of the unlocked accounts to itself. Default time between blocks is 10s. But you can change it by setting `BLOCKS_FREQ` env variable.
 ```
 export BLOCKS_FREQ=5
 ```

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

### Adding unlocked accounts
* Generate BIP39 English 24 word mnemonic - you can use [https://iancoleman.io/bip39](https://iancoleman.io/bip39)
* Save `Private Key` and `Address` from first path `m/44'/60'/0'/0/0`
* Use it in Parity UI to restore account - set password to `test`
* Start the node using `make run` and go to `http://127.0.0.1:8180`
* Go to `Accounts` and `+Accounts  -> PRIVATE KEY`. Use generated private key and set password to `test`.
* Go to new account and export it. Save downloaded file in `/keys` directory
* Add address of created account to table in `nfdev.json` and give it some ETH
* Add address of created account to `supervisord.conf` as `--unlock` parameter

Recepie was changing during time so here we have a bit mess in our unlocked accounts:
- Wallets 1-9 are using `m/44'/60'/0'/0` derivation path
- Wallets 10-18 are using unknown derivation path
- Wallets 19-28 are using `m/44'/60'/0'/0/0` derivation path
