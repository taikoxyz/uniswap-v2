# UniswapV2 contracts and deployments
UniswapV2 contracts

This is needed for Gwyneth testing.
Currently available repository: https://github.com/taikoxyz/uniswap-v2-deploy was good till today, but it is lacking smart contracts (deploys from bytecode) and thus smart contract verification is not possible.

## Usage
After prereuqisites (such as nodes are up and running) install uniswap and tokens accordingly.

### Example
(If L1 or other network is running on localhost 32002)

```shell
$ forge script script/UniswapDeployer.s.sol --rpc-url http://localhost:32002 --broadcast --legacy
$ forge script script/DeployTokens.s.sol --rpc-url http://localhost:32002 --broadcast --legacy
```
