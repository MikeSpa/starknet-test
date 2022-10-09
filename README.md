# StarkNet
StarkNet is a permissionless decentralized ZK-Rollup operating as an L2 network over Ethereum, where any dApp can achieve unlimited scale for its computation, without compromising Ethereum’s composability and security.

Cairo is a programming language for writing provable programs, where one party can prove to another that a certain computation was executed correctly. Cairo and similar proof systems can be used to provide scalability to blockchains.

StarkNet uses the Cairo programming language both for its infrastructure and for writing StarkNet contracts.


## Deploy contracts

### StarkNet Account

0x000bf956aa76fa0d30bac1c0fab5adc4e975ec1f78354c880b95e5f2e93fd901

### Compiling the contract

compile contract with `starknet-compile`:

```bash
starknet-compile contract.cairo \
    --output contract_compiled.json \
    --abi contract_abi.json
```

### Declare the contract on StarkNet testnet

```bash
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
```

```bash
starknet declare --contract contract_compiled.json
```
Output:
```bash
Sending the transaction with max_fee: 0.000000 ETH.
Declare transaction was sent.
Contract class hash: 0x68704d18de8ccf71da7c9761ee53efd44dcfcfd512eddfac9c396e7d175e234
Transaction hash: 0x6f6cc041859084415c877ea5fbf69c83cb07f039315894b5e864caaf44ab6fe
```


### Deploy the contract on StarkNet testnet

```bash
starknet deploy --class_hash 0x68704d18de8ccf71da7c9761ee53efd44dcfcfd512eddfac9c396e7d175e234
```
Output:
```
Sending the transaction with max_fee: 0.000000 ETH.
Invoke transaction for contract deployment was sent.
Contract address: 0x003ba898fcd7c865edbac67237a7455291a1e172feb385d077eb60e83768a7e2
Transaction hash: 0x400da4c8d418bced729917d3fe19c9d1988d07e478e962fd6c6730fab9b874a
```
```
export CONTRACT_ADDRESS=0x003ba898fcd7c865edbac67237a7455291a1e172feb385d077eb60e83768a7e2
```

### Interact with the contract

Calling `increade_balance()`:
```
starknet invoke \
    --address ${CONTRACT_ADDRESS} \
    --abi contract_abi.json \
    --function increase_balance \
    --inputs 1234
```

To look at the tx status:
```
starknet tx_status --hash TRANSACTION_HASH
```

Output:
```
{
    "tx_status": "RECEIVED"
}
```
Then:
```
{
    "block_hash": "0x332dcb1d697cb21c933927618a9ffb19596759df8337573ce0d0c903205dc75",
    "tx_status": "ACCEPTED_ON_L2"
}
```

Query the balance:
```
starknet call \
    --address ${CONTRACT_ADDRESS} \
    --abi contract_abi.json \
    --function get_balance
```
Output: 1234

[More CLI command](https://www.cairo-lang.org/docs/hello_starknet/cli.html)

## Interaction with L1 contracts

Account address: 0x07a5a3a45176a9ad5c606bb3a8dde5574c594c93f79d9b5f162548e352247ba7

l1l2.cairo contract on StarkNet goerli testnet: 0x012336d392d22f506403120d38d8c023b5e513bf02b14e7a507728b2e13c4300

```
starknet call --address ${L1L2_CONTRACT_ADDRESS} --abi l1l2_abi.json --function get_balance --inputs 8
```
returns 0.
Add 1000 on the contract:
```
starknet invoke --address ${L1L2_CONTRACT_ADDRESS} --abi l1l2_abi.json --function increase_balance --inputs 8 1000
```
> tx.hash: 0x5505caf11ecc71e839898b96e3f2f7daa49f47a1d2f8b0f2c0ac5373a25eb9c
```
starknet call --address ${L1L2_CONTRACT_ADDRESS} --abi l1l2_abi.json --function get_balance --inputs 8
```
returns 1000.
Then withdraw 400:
```
starknet invoke --address ${L1L2_CONTRACT_ADDRESS} --abi l1l2_abi.json --function withdraw --inputs 8 400
```
> tx.hash: 0x63cd725c9325eaf703cb6e592b03f575fd3288b03e7adcbdb74e12a043807c5

Checking the balance again:
```
starknet call --address ${L1L2_CONTRACT_ADDRESS} --abi l1l2_abi.json --function get_balance --inputs 8
```
now returns 600.
Now we can withdraw that amount on Ethereum testnet goerli, by calling the withdraw() fct on [0x8359E4B0152ed5A731162D3c7B0D8D56edB165A0](https://goerli.etherscan.io/address/0x8359E4B0152ed5A731162D3c7B0D8D56edB165A0#code)


## Sources

[Cairo lang](https://www.cairo-lang.org/)