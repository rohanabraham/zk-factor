# zk-factor
Account Abstraction gets more factors

## Getting Started
[Start your codespace from the codespace dropdown](https://docs.github.com/en/codespaces/getting-started/quickstart).

Get the sandbox, aztec-cli and other tooling with this command:

```bash
bash -i <(curl -s install.aztec.network)
```

Start the sandbox with:

```bash
aztec-sandbox
```

## Install packages

```bash
yarn install
```

## Compile

```bash
aztec-nargo compile
```

or

```bash
yarn compile
```

## Codegen

Generate the contract artifact json and typescript interface

```bash
yarn codegen
```

## Deploy

Add `ADMIN` to your environment. Get an address from Docker

```bash
ADMIN="0x08d13936ea0ab52f57e96b06644950e143c4fe08162cd84fff63bc9135ce4726"
```

Add `PRIVATE_KEY` to your environment. Get this PRIVATE_KEY address from Docker

```bash
PRIVATE_KEY="0x2153536ff6628eee01cf4024889ff977a18d9fa61d0e414422f7681cf085c281"
```

Initial Accounts:
Address: 0x08d13936ea0ab52f57e96b06644950e143c4fe08162cd84fff63bc9135ce4726
Partial Address: 0x106d1afe5167a76d6d57137efc62a1705bf8e4a770a03cb656e36c63ff430df6
Private Key: 0x2153536ff6628eee01cf4024889ff977a18d9fa61d0e414422f7681cf085c281
Public Key: 0x27c20118733174347b8082f578a7d8fb84b3ad38be293715eee8119ee5cd8a6d0d6b7d8124b37359663e75bcd2756f544a93b821a06f8e33fba68cc8029794d9


```bash
aztec-cli deploy target/zk_factor-ZKFactor.json --private-key $PRIVATE_KEY
```
You'll get an output like this
Contract deployed at 0x14f5c48e6098e63d7873d1474660aa1ceda149f05075ecfa9c611c98b7a120e6

Contract partial address 0x0a8fd8cc3797cfb1f6f6d6cf57b444f4a197dc63ee860a1dd47f967ba56cd2bf

```bash
CONTRACT="0x14f5c48e6098e63d7873d1474660aa1ceda149f05075ecfa9c611c98b7a120e6"
```

Set Reference points to the contract
```bash
aztec-cli send setReferencePoint --contract-artifact target/zk_factor-ZKFactor.json --contract-address $CONTRACT --args 0 4 6 --private-key $PRIVATE_KEY
```

Get Reference points from the contract
```bash
aztec-cli send verifyReferencePoint --contract-artifact target/zk_factor-ZKFactor.json --contract-address $CONTRACT --args 0 4 6 --private-key $PRIVATE_KEY
```


## Test

```bash
yarn test
```

## Error resolution

### Update Nodejs and Noir dependencies

```bash
aztec-cli update
```
