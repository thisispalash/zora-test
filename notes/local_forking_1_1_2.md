# Local Forking

The primary issue is that contract version on mainnet is 1.1.2 and on sepolia is 1.0.0. As such, 
`deployCreatorCoin` does not exist on sepolia, among other things (like hooks).

## `ZoraFactoryImpl`

The following addresses are needed for the constructor of the most recent version.

### mainnet

To confirm these values, please run,

`$ cast call <addr> "contractVersion()" --rpc-url https://mainnet.base.org | cast --to-ascii`


| | version | address | 
| :---: | :---: | --- |
| contract | 1.1.2 | [`0x0e2ea62e5377d46fef114a60afbe3d5ea7490577`](https://basescan.org/address/0x0e2ea62e5377d46fef114a60afbe3d5ea7490577#code) |
| `_coinImpl` | 1.1.0 | [`0x45Bf86430af7CD071Ea23aE52325A78C8d12aD5a`](https://basescan.org/address/0x45Bf86430af7CD071Ea23aE52325A78C8d12aD5a#code) |
| `_coinV4Impl` | 1.1.0 | [`0xca72309AaF706d290E08608b1Af47943902f69b2`](https://basescan.org/address/0xca72309AaF706d290E08608b1Af47943902f69b2#code) |
| `_creatorCoinImpl` | 1.1.0 | [`0x88CC4E08C7608723f3E44e17aC669Fb43b6A8313`](https://basescan.org/address/0x88CC4E08C7608723f3E44e17aC669Fb43b6A8313#code) | 
| `_contentCoinHook` | 1.1.2 | [`0x9ea932730A7787000042e34390B8E435dD839040`](https://basescan.org/address/0x9ea932730A7787000042e34390B8E435dD839040#code) |
| `_creatorCoinHook` | 1.1.2 | [`0xd61A675F8a0c67A73DC3B54FB7318B4D91409040`](https://basescan.org/address/0xd61A675F8a0c67A73DC3B54FB7318B4D91409040#code) |

### sepolia

The main issue is that the contract version is 1.0.0

Hence, we need to fork the chain and [run locally](../script/TestCreatorCoin.s.sol) to test correctness of code.

Correctness of user experience needs to be tested on mainnet (rip).

## Uniswap Related