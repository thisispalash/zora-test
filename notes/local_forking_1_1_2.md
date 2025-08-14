# Local Forking

The primary issue is that contract version on mainnet is 1.1.2 and on sepolia is 1.0.0. As such, 
`deployCreatorCoin` does not exist on sepolia, among other things (like hooks).

As a result, a test script contract is created to fork locally ~ [`TestCreatorCoin`](../script/TestCreatorCoin.s.sol).

Currently, all implementations deploy, but `deployCreatorCoin` is reverting. Not sure why. See logs 
[below](#current-logs).

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


## Current Logs

```
[⠊] Compiling...
No files changed, compilation skipped
Traces:
  [637136356] TestCreatorCoin::run()
    ├─ [0] console::log("=== Upgrading Zora Factory on Base Sepolia Fork ===") [staticcall]
    │   └─ ← [Stop]
    ├─ [7389] 0x777777751622c0d3258f214F9DF38E35BF45baF3::owner() [staticcall]
    │   ├─ [2582] 0x1702d15066B6F5CcCE94Ca1d9e353D1F073448c4::owner() [delegatecall]
    │   │   └─ ← [Return] 0x5F14C23983c9e0840Dc60dA880349622f0785420
    │   └─ ← [Return] 0x5F14C23983c9e0840Dc60dA880349622f0785420
    ├─ [0] console::log("Admin owner:", 0x5F14C23983c9e0840Dc60dA880349622f0785420) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::startBroadcast()
    │   └─ ← [Return]
    ├─ [7956617] → new Coin@0x53Eba1e079F885482238EE8bf01C4A9f09DE458f
    │   ├─ emit Initialized(version: 1)
    │   ├─ emit Initialized(version: 1)
    │   └─ ← [Return] 39555 bytes of code
    ├─ [0] console::log("Coin impl:", Coin: [0x53Eba1e079F885482238EE8bf01C4A9f09DE458f]) [staticcall]
    │   └─ ← [Stop]
    ├─ [6011619] → new CoinV4@0x56186c1e64ca8043DEF78d06Aff222212ea5df71
    │   ├─ emit Initialized(version: 1)
    │   └─ ← [Return] 29876 bytes of code
    ├─ [0] console::log("CoinV4 impl:", CoinV4: [0x56186c1e64ca8043DEF78d06Aff222212ea5df71]) [staticcall]
    │   └─ ← [Stop]
    ├─ [6271337] → new CreatorCoin@0x056e4a859558a3975761abD7385506BC4D8a8E60
    │   ├─ emit Initialized(version: 1)
    │   ├─ emit Initialized(version: 1)
    │   └─ ← [Return] 31149 bytes of code
    ├─ [0] console::log("CreatorCoin impl:", CreatorCoin: [0x056e4a859558a3975761abD7385506BC4D8a8E60]) [staticcall]
    │   └─ ← [Stop]
    ├─ [601208] → new HookUpgradeGate@0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99
    │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: TestCreatorCoin: [0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519])
    │   └─ ← [Return] 2861 bytes of code
    ├─ [0] console::log("HookUpgradeGate:", HookUpgradeGate: [0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99]) [staticcall]
    │   └─ ← [Stop]
    ├─ [18666160] → new HooksDeployer@0x093Dc47bBd22C27D4e6996bdD34cb7eE7FfbA657
    │   └─ ← [Return] 93046 bytes of code
    ├─ [91146718] HooksDeployer::deployContentCoinHook(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, 0x777777751622c0d3258f214F9DF38E35BF45baF3, [0x492E6456D9528771018DeB9E87ef7750EF184104, 0xAc631556d3d4019C95769033B5E719dD77124BAc], HookUpgradeGate: [0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99])
    │   ├─ [8458314] → new ContentCoinHook@0xA111eB372C90507BDF935278d379fB0B53e2D040
    │   │   └─ ← [Return] 41900 bytes of code
    │   └─ ← [Return] ContentCoinHook: [0xA111eB372C90507BDF935278d379fB0B53e2D040], 0x0000000000000000000000000000000000000000000000000000000000002092
    ├─ [0] console::log("ContentCoinHook deployed!") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] console::log("ContentCoinHook:", ContentCoinHook: [0xA111eB372C90507BDF935278d379fB0B53e2D040]) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::toString(0x0000000000000000000000000000000000000000000000000000000000002092) [staticcall]
    │   └─ ← [Return] "0x0000000000000000000000000000000000000000000000000000000000002092"
    ├─ [0] console::log("ContentCoinHook salt:", "0x0000000000000000000000000000000000000000000000000000000000002092") [staticcall]
    │   └─ ← [Stop]
    ├─ [494472928] HooksDeployer::deployCreatorCoinHook(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, 0x777777751622c0d3258f214F9DF38E35BF45baF3, [0x492E6456D9528771018DeB9E87ef7750EF184104, 0xAc631556d3d4019C95769033B5E719dD77124BAc], HookUpgradeGate: [0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99])
    │   ├─ [8152776] → new CreatorCoinHook@0x71F5b2f7F909b9A463918ba9bfC776361fC31040
    │   │   └─ ← [Return] 40375 bytes of code
    │   └─ ← [Return] CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], 0x000000000000000000000000000000000000000000000000000000000000c583
    ├─ [0] console::log("CreatorCoinHook deployed!") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] console::log("CreatorCoinHook:", CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040]) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::toString(0x000000000000000000000000000000000000000000000000000000000000c583) [staticcall]
    │   └─ ← [Return] "0x000000000000000000000000000000000000000000000000000000000000c583"
    ├─ [0] console::log("CreatorCoinHook salt:", "0x000000000000000000000000000000000000000000000000000000000000c583") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    ├─ [0] VM::startBroadcast()
    │   └─ ← [Return]
    ├─ [6491436] → new ZoraFactoryImpl@0x10156cbC809Ab21D968B392882cA58685264c591
    │   ├─ emit Initialized(version: 18446744073709551615 [1.844e19])
    │   └─ ← [Return] 32284 bytes of code
    ├─ [0] console::log("New factory impl:", ZoraFactoryImpl: [0x10156cbC809Ab21D968B392882cA58685264c591]) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    ├─ [0] VM::startPrank(0x5F14C23983c9e0840Dc60dA880349622f0785420)
    │   └─ ← [Return]
    ├─ [9919] 0x777777751622c0d3258f214F9DF38E35BF45baF3::upgradeToAndCall(ZoraFactoryImpl: [0x10156cbC809Ab21D968B392882cA58685264c591], 0x)
    │   ├─ [9603] 0x1702d15066B6F5CcCE94Ca1d9e353D1F073448c4::upgradeToAndCall(ZoraFactoryImpl: [0x10156cbC809Ab21D968B392882cA58685264c591], 0x) [delegatecall]
    │   │   ├─ [1288] ZoraFactoryImpl::contractName()
    │   │   │   └─ ← [Return] "ZoraCoinFactory"
    │   │   ├─ [1196] ZoraFactoryImpl::proxiableUUID() [staticcall]
    │   │   │   └─ ← [Return] 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
    │   │   ├─ emit Upgraded(implementation: ZoraFactoryImpl: [0x10156cbC809Ab21D968B392882cA58685264c591])
    │   │   └─ ← [Stop]
    │   └─ ← [Return]
    ├─ [0] VM::stopPrank()
    │   └─ ← [Return]
    ├─ [0] console::log("=== Factory upgraded successfully ===") [staticcall]
    │   └─ ← [Stop]
    ├─ [11999] 0x777777751622c0d3258f214F9DF38E35BF45baF3::deployCreatorCoin(ECRecover: [0x0000000000000000000000000000000000000001], [], "", "", "", 0x00, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   ├─ [11616] ZoraFactoryImpl::deployCreatorCoin(ECRecover: [0x0000000000000000000000000000000000000001], [], "", "", "", 0x00, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000) [delegatecall]
    │   │   └─ ← [Revert] EvmError: Revert
    │   └─ ← [Revert] EvmError: Revert
    ├─ [0] console::log("deployCreatorCoin selector exists (reverted as expected with bad params)") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::startBroadcast()
    │   └─ ← [Return]
    ├─ [1381181] → new Manager@0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2
    │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
    │   └─ ← [Return] 6773 bytes of code
    ├─ [0] console::log("Manager:", Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2]) [staticcall]
    │   └─ ← [Stop]
    ├─ [499538] → new WalletFactory@0xE527DDaC2592FAa45884a0B78E4D377a5D3dF8cc
    │   └─ ← [Return] 2380 bytes of code
    ├─ [0] console::log("WalletFactory:", WalletFactory: [0xE527DDaC2592FAa45884a0B78E4D377a5D3dF8cc]) [staticcall]
    │   └─ ← [Stop]
    ├─ [23857] Manager::updateWalletFactory(WalletFactory: [0xE527DDaC2592FAa45884a0B78E4D377a5D3dF8cc])
    │   └─ ← [Return]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    ├─ [0] console::log("=== Testing onboard flow ===") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::startBroadcast()
    │   └─ ← [Return]
    ├─ [3161639] Manager::onboard("demo-01", "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "tt")
    │   ├─ [181088] WalletFactory::createCoinbaseWallet(0x0000000000000000000000000000000000000000)
    │   │   ├─ [168405] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::createAccount([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1)
    │   │   │   ├─ [34337] → new <unknown>@0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   │   │   │   └─ ← [Return] 61 bytes of code
    │   │   │   ├─ [96868] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad::initialize([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2])
    │   │   │   │   ├─ [94080] 0x000100abaad02f1cfC8Bbe32bD5a564817339E72::initialize([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2]) [delegatecall]
    │   │   │   │   │   ├─ emit AddOwner(index: 0, owner: 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2)
    │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   └─ ← [Return]
    │   │   │   └─ ← [Return] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   │   ├─ [1552] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::getAddress([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1) [staticcall]
    │   │   │   └─ ← [Return] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   │   ├─ emit NewCoinbaseWallet(wallet: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad)
    │   │   └─ ← [Return] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   ├─ emit WalletCreated(wallet: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad)
    │   ├─ [246620] 0x0Ba958A449701907302e28F5955fa9d16dDC45c3::createSmartWallet([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1)
    │   │   ├─ [237636] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::createAccount([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1)
    │   │   │   ├─ [34337] → new <unknown>@0x551173E570B4985D5bb9CADD448A169E0290b337
    │   │   │   │   └─ ← [Return] 61 bytes of code
    │   │   │   ├─ [165370] 0x551173E570B4985D5bb9CADD448A169E0290b337::initialize([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2])
    │   │   │   │   ├─ [165064] 0x000100abaad02f1cfC8Bbe32bD5a564817339E72::initialize([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2]) [delegatecall]
    │   │   │   │   │   ├─ emit AddOwner(index: 0, owner: 0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad)
    │   │   │   │   │   ├─ emit AddOwner(index: 1, owner: 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2)
    │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   └─ ← [Return]
    │   │   │   └─ ← [Return] 0x551173E570B4985D5bb9CADD448A169E0290b337
    │   │   ├─ [1925] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::getAddress([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1) [staticcall]
    │   │   │   └─ ← [Return] 0x551173E570B4985D5bb9CADD448A169E0290b337
    │   │   ├─ emit ZoraSmartWalletCreated(param0: 0x551173E570B4985D5bb9CADD448A169E0290b337, param1: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad, param2: [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], param3: 1)
    │   │   └─ ← [Return] 0x551173E570B4985D5bb9CADD448A169E0290b337
    │   ├─ emit ZoraAccountCreated(zoraAccount: 0x551173E570B4985D5bb9CADD448A169E0290b337)
    │   ├─ [2703285] 0x777777751622c0d3258f214F9DF38E35BF45baF3::deployCreatorCoin(0x5E07a41245E013Cb7933928f65304E365a71c7Ad, [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x551173E570B4985D5bb9CADD448A169E0290b337, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "demo-01.tt", "demo-01.tt", 0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000001111111111166b7fe7bd91427724b487980afc6900000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001800000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee2d80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000e4840000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000b1a2bc2ec50000, Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], 0x8d2d5259dc6233909fc636eadb3c4e02f648063a9078741f90cd0cdd1356a6d6)
    │   │   ├─ [2702772] ZoraFactoryImpl::deployCreatorCoin(0x5E07a41245E013Cb7933928f65304E365a71c7Ad, [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x551173E570B4985D5bb9CADD448A169E0290b337, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "demo-01.tt", "demo-01.tt", 0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000001111111111166b7fe7bd91427724b487980afc6900000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001800000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee2d80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000e4840000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000b1a2bc2ec50000, Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], 0x8d2d5259dc6233909fc636eadb3c4e02f648063a9078741f90cd0cdd1356a6d6) [delegatecall]
    │   │   │   ├─ [9031] → new <unknown>@0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A
    │   │   │   │   └─ ← [Return] 45 bytes of code
    │   │   │   ├─ [2571590] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A::initialize(0x5E07a41245E013Cb7933928f65304E365a71c7Ad, [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x551173E570B4985D5bb9CADD448A169E0290b337, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "demo-01.tt", "demo-01.tt", Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], 0x1111111111166b7FE7bd91427724B487980aFc69, PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), 3047720871683109467712356580791 [3.047e30], PoolConfiguration({ version: 4, numPositions: 12, fee: 30000 [3e4], tickSpacing: 200, numDiscoveryPositions: [11], tickLower: [-58600 [-5.86e4]], tickUpper: [73000 [7.3e4]], maxDiscoverySupplyShare: [50000000000000000 [5e16]] }))
    │   │   │   │   ├─ [2571172] CreatorCoin::initialize(0x5E07a41245E013Cb7933928f65304E365a71c7Ad, [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x551173E570B4985D5bb9CADD448A169E0290b337, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "demo-01.tt", "demo-01.tt", Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], 0x1111111111166b7FE7bd91427724B487980aFc69, PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), 3047720871683109467712356580791 [3.047e30], PoolConfiguration({ version: 4, numPositions: 12, fee: 30000 [3e4], tickSpacing: 200, numDiscoveryPositions: [11], tickLower: [-58600 [-5.86e4]], tickUpper: [73000 [7.3e4]], maxDiscoverySupplyShare: [50000000000000000 [5e16]] })) [delegatecall]
    │   │   │   │   │   ├─ emit NameAndSymbolUpdated(caller: 0x777777751622c0d3258f214F9DF38E35BF45baF3, newName: "demo-01.tt", newSymbol: "demo-01.tt")
    │   │   │   │   │   ├─ emit OwnerUpdated(caller: 0x777777751622c0d3258f214F9DF38E35BF45baF3, prevOwner: 0x0000000000000000000000000000000000000000, newOwner: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad)
    │   │   │   │   │   ├─ emit OwnerUpdated(caller: 0x777777751622c0d3258f214F9DF38E35BF45baF3, prevOwner: 0x0000000000000000000000000000000000000000, newOwner: 0x551173E570B4985D5bb9CADD448A169E0290b337)
    │   │   │   │   │   ├─ emit OwnerUpdated(caller: 0x777777751622c0d3258f214F9DF38E35BF45baF3, prevOwner: 0x0000000000000000000000000000000000000000, newOwner: Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2])
    │   │   │   │   │   ├─ emit CoinPayoutRecipientUpdated(caller: 0x777777751622c0d3258f214F9DF38E35BF45baF3, prevRecipient: 0x0000000000000000000000000000000000000000, newRecipient: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad)
    │   │   │   │   │   ├─ emit ContractMetadataUpdated(caller: 0x777777751622c0d3258f214F9DF38E35BF45baF3, newURI: "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", name: "demo-01.tt")
    │   │   │   │   │   ├─ emit ContractURIUpdated()
    │   │   │   │   │   ├─ emit Transfer(from: 0x0000000000000000000000000000000000000000, to: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, value: 1000000000000000000000000000 [1e27])
    │   │   │   │   │   ├─ emit CoinTransfer(sender: 0x0000000000000000000000000000000000000000, recipient: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, amount: 1000000000000000000000000000 [1e27], senderBalance: 0, recipientBalance: 1000000000000000000000000000 [1e27])
    │   │   │   │   │   ├─ emit Transfer(from: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, to: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], value: 500000000000000000000000000 [5e26])
    │   │   │   │   │   ├─ emit CoinTransfer(sender: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, recipient: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], amount: 500000000000000000000000000 [5e26], senderBalance: 500000000000000000000000000 [5e26], recipientBalance: 500000000000000000000000000 [5e26])
    │   │   │   │   │   ├─ [1662984] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::initialize(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), 3047720871683109467712356580791 [3.047e30])
    │   │   │   │   │   │   ├─ emit Initialize(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], sqrtPriceX96: 3047720871683109467712356580791 [3.047e30], tick: 73000 [7.3e4])
    │   │   │   │   │   │   ├─ [1632826] CreatorCoinHook::afterInitialize(0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), 3047720871683109467712356580791 [3.047e30], 73000 [7.3e4])
    │   │   │   │   │   │   │   ├─ [1733] 0x777777751622c0d3258f214F9DF38E35BF45baF3::getVersionForDeployedCoin(0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A) [staticcall]
    │   │   │   │   │   │   │   │   ├─ [1423] ZoraFactoryImpl::getVersionForDeployedCoin(0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A) [delegatecall]
    │   │   │   │   │   │   │   │   │   └─ ← [Return] 4
    │   │   │   │   │   │   │   │   └─ ← [Return] 4
    │   │   │   │   │   │   │   ├─ [10468] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A::getPoolConfiguration() [staticcall]
    │   │   │   │   │   │   │   │   ├─ [10206] CreatorCoin::getPoolConfiguration() [delegatecall]
    │   │   │   │   │   │   │   │   │   └─ ← [Return] PoolConfiguration({ version: 4, numPositions: 12, fee: 30000 [3e4], tickSpacing: 200, numDiscoveryPositions: [11], tickLower: [-58600 [-5.86e4]], tickUpper: [73000 [7.3e4]], maxDiscoverySupplyShare: [50000000000000000 [5e16]] })
    │   │   │   │   │   │   │   │   └─ ← [Return] PoolConfiguration({ version: 4, numPositions: 12, fee: 30000 [3e4], tickSpacing: 200, numDiscoveryPositions: [11], tickLower: [-58600 [-5.86e4]], tickUpper: [73000 [7.3e4]], maxDiscoverySupplyShare: [50000000000000000 [5e16]] })
    │   │   │   │   │   │   │   ├─ [1050987] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::unlock(0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000058000000000000000000000000000000000000000000000000000000000000000200000000000000000000000001111111111166b7fe7bd91427724b487980afc69000000000000000000000000a14d07a5cbdd56b3ce693c3f98a267c549c2e33a000000000000000000000000000000000000000000000000000000000000753000000000000000000000000000000000000000000000000000000000000000c800000000000000000000000071f5b2f7f909b9a463918ba9bfc776361fc3104000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b180000000000000000000000000000000000000000000000000000000000011d28000000000000000000000000000000000000000000000c8744ca8869892ee885ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000ef100000000000000000000000000000000000000000000016a02dba3753371cccb6ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000c03000000000000000000000000000000000000000000000294f8c6790e7879b4ba0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b180000000000000000000000000000000000000000000000000000000000009150000000000000000000000000000000000000000000004b8e37b6c6a64257644cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b180000000000000000000000000000000000000000000000000000000000006270000000000000000000000000000000000000000000008a9f59e75bd8ec3d79f9ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000339000000000000000000000000000000000000000000000ffd05b396f171739d83effffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000057800000000000000000000000000000000000000000001d83fbc731b9a0ec9037effffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd69800000000000000000000000000000000000000000003833484cfa192620f4ffdffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa7b800000000000000000000000000000000000000000006f8d003b46e63a3b42b41ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff78d80000000000000000000000000000000000000000000f2c7e062916c75a4b8e87ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff49f80000000000000000000000000000000000000000002ad2494fdaf53b59077e55fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27660ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b1800000000000000000000000000000000000000001cbd35d471f3795f7aa55b48)
    │   │   │   │   │   │   │   │   ├─ [1048758] CreatorCoinHook::unlockCallback(0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000058000000000000000000000000000000000000000000000000000000000000000200000000000000000000000001111111111166b7fe7bd91427724b487980afc69000000000000000000000000a14d07a5cbdd56b3ce693c3f98a267c549c2e33a000000000000000000000000000000000000000000000000000000000000753000000000000000000000000000000000000000000000000000000000000000c800000000000000000000000071f5b2f7f909b9a463918ba9bfc776361fc3104000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b180000000000000000000000000000000000000000000000000000000000011d28000000000000000000000000000000000000000000000c8744ca8869892ee885ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000ef100000000000000000000000000000000000000000000016a02dba3753371cccb6ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000c03000000000000000000000000000000000000000000000294f8c6790e7879b4ba0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b180000000000000000000000000000000000000000000000000000000000009150000000000000000000000000000000000000000000004b8e37b6c6a64257644cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b180000000000000000000000000000000000000000000000000000000000006270000000000000000000000000000000000000000000008a9f59e75bd8ec3d79f9ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000339000000000000000000000000000000000000000000000ffd05b396f171739d83effffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18000000000000000000000000000000000000000000000000000000000000057800000000000000000000000000000000000000000001d83fbc731b9a0ec9037effffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd69800000000000000000000000000000000000000000003833484cfa192620f4ffdffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa7b800000000000000000000000000000000000000000006f8d003b46e63a3b42b41ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff78d80000000000000000000000000000000000000000000f2c7e062916c75a4b8e87ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b18ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff49f80000000000000000000000000000000000000000002ad2494fdaf53b59077e55fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27660ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b1800000000000000000000000000000000000000001cbd35d471f3795f7aa55b48)
    │   │   │   │   │   │   │   │   │   ├─ [140439] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 73000 [7.3e4], liquidityDelta: 59163665168713261181061 [5.916e22], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 73000 [7.3e4], liquidityDelta: 59163665168713261181061 [5.916e22], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938731 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65327] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 61200 [6.12e4], liquidityDelta: 106846836681833644346550 [1.068e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 61200 [6.12e4], liquidityDelta: 106846836681833644346550 [1.068e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938744 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [87099] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 49200 [4.92e4], liquidityDelta: 195084435793890506394528 [1.95e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 49200 [4.92e4], liquidityDelta: 195084435793890506394528 [1.95e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938732 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65231] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 37200 [3.72e4], liquidityDelta: 356800938488225374626892 [3.568e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 37200 [3.72e4], liquidityDelta: 356800938488225374626892 [3.568e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938734 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65263] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 25200 [2.52e4], liquidityDelta: 654626085191307088460281 [6.546e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 25200 [2.52e4], liquidityDelta: 654626085191307088460281 [6.546e23], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938732 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65263] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 13200 [1.32e4], liquidityDelta: 1208046949306367204775998 [1.208e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 13200 [1.32e4], liquidityDelta: 1208046949306367204775998 [1.208e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938730 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65263] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: 1400, liquidityDelta: 2230132704018766181761918 [2.23e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: 1400, liquidityDelta: 2230132704018766181761918 [2.23e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938729 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [87143] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: -10600 [-1.06e4], liquidityDelta: 4246376268837027211857917 [4.246e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: -10600 [-1.06e4], liquidityDelta: 4246376268837027211857917 [4.246e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938729 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65211] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: -22600 [-2.26e4], liquidityDelta: 8428538995166430796983105 [8.428e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: -22600 [-2.26e4], liquidityDelta: 8428538995166430796983105 [8.428e24], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938729 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65243] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: -34600 [-3.46e4], liquidityDelta: 18343996153130073155407495 [1.834e25], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: -34600 [-3.46e4], liquidityDelta: 18343996153130073155407495 [1.834e25], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938729 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [65243] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -58600 [-5.86e4], tickUpper: -46600 [-4.66e4], liquidityDelta: 51767933751715540794572373 [5.176e25], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -58600 [-5.86e4], tickUpper: -46600 [-4.66e4], liquidityDelta: 51767933751715540794572373 [5.176e25], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920936190736101880159040938729 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [87230] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::modifyLiquidity(PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), ModifyLiquidityParams({ tickLower: -887200 [-8.872e5], tickUpper: -58600 [-5.86e4], liquidityDelta: 8894321459249202552547662664 [8.894e27], salt: 0x0000000000000000000000000000000000000000000000000000000000000000 }), 0x)
    │   │   │   │   │   │   │   │   │   │   ├─ emit ModifyLiquidity(id: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], tickLower: -887200 [-8.872e5], tickUpper: -58600 [-5.86e4], liquidityDelta: 8894321459249202552547662664 [8.894e27], salt: 0x0000000000000000000000000000000000000000000000000000000000000000)
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 340282366920463463463374607431768211424 [3.402e38], 0
    │   │   │   │   │   │   │   │   │   ├─ [859] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::exttload(0x47cc92f97e3a0be5c1198d694b782699dd4cc0652b7d84fe3a324d58f772ed4a) [staticcall]
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 0x0000000000000000000000000000000000000000000000000000000000000000
    │   │   │   │   │   │   │   │   │   ├─ [859] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::exttload(0x17b77072dd63f877ecd57ba9dcddcb4c6737826b426ed7f6543c903fb40dd838) [staticcall]
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 0xfffffffffffffffffffffffffffffffffffffffffe6268e1b017bfe18c000000
    │   │   │   │   │   │   │   │   │   ├─ [5148] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::sync(0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A)
    │   │   │   │   │   │   │   │   │   │   ├─ [3775] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A::balanceOf(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408) [staticcall]
    │   │   │   │   │   │   │   │   │   │   │   ├─ [3603] CreatorCoin::balanceOf(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408) [delegatecall]
    │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 0
    │   │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 0
    │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   ├─ [32198] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A::transfer(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, 500000000000000000000000000 [5e26])
    │   │   │   │   │   │   │   │   │   │   ├─ [32020] CreatorCoin::transfer(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, 500000000000000000000000000 [5e26]) [delegatecall]
    │   │   │   │   │   │   │   │   │   │   │   ├─ emit Transfer(from: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], to: 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, value: 500000000000000000000000000 [5e26])
    │   │   │   │   │   │   │   │   │   │   │   ├─ emit CoinTransfer(sender: CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], recipient: 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, amount: 500000000000000000000000000 [5e26], senderBalance: 0, recipientBalance: 500000000000000000000000000 [5e26])
    │   │   │   │   │   │   │   │   │   │   │   └─ ← [Return] true
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] true
    │   │   │   │   │   │   │   │   │   ├─ [3749] 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408::settle()
    │   │   │   │   │   │   │   │   │   │   ├─ [1775] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A::balanceOf(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408) [staticcall]
    │   │   │   │   │   │   │   │   │   │   │   ├─ [1603] CreatorCoin::balanceOf(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408) [delegatecall]
    │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 500000000000000000000000000 [5e26]
    │   │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 500000000000000000000000000 [5e26]
    │   │   │   │   │   │   │   │   │   │   └─ ← [Return] 500000000000000000000000000 [5e26]
    │   │   │   │   │   │   │   │   │   └─ ← [Return] 0x
    │   │   │   │   │   │   │   │   └─ ← [Return] 0x
    │   │   │   │   │   │   │   └─ ← [Return] 0x6fe7e6eb
    │   │   │   │   │   │   └─ ← [Return] 73000 [7.3e4]
    │   │   │   │   │   ├─ emit Initialized(version: 1)
    │   │   │   │   │   └─ ← [Return]
    │   │   │   │   └─ ← [Return]
    │   │   │   ├─ [1840] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A::contractVersion() [staticcall]
    │   │   │   │   ├─ [1662] CreatorCoin::contractVersion() [delegatecall]
    │   │   │   │   │   └─ ← [Return] "1.1.2"
    │   │   │   │   └─ ← [Return] "1.1.2"
    │   │   │   ├─ emit CreatorCoinCreated(caller: Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], payoutRecipient: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad, platformReferrer: Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], currency: 0x1111111111166b7FE7bd91427724B487980aFc69, uri: "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", name: "demo-01.tt", symbol: "demo-01.tt", coin: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, poolKey: PoolKey({ currency0: 0x1111111111166b7FE7bd91427724B487980aFc69, currency1: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A, fee: 30000 [3e4], tickSpacing: 200, hooks: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040 }), poolKeyHash: 0xd0e18cf512990034c0959b28446d049b2c0f6a02730a320afa03229bed171985, version: "1.1.2")
    │   │   │   └─ ← [Return] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A
    │   │   └─ ← [Return] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A
    │   ├─ emit CreatorCoinCreated(creatorCoin: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A)
    │   └─ ← [Return] 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A
    ├─ [0] console::log("Onboard successful!") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] console::log("Creator coin:", 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    └─ ← [Return]


Script ran successfully.

== Logs ==
  === Upgrading Zora Factory on Base Sepolia Fork ===
  Admin owner: 0x5F14C23983c9e0840Dc60dA880349622f0785420
  Coin impl: 0x53Eba1e079F885482238EE8bf01C4A9f09DE458f
  CoinV4 impl: 0x56186c1e64ca8043DEF78d06Aff222212ea5df71
  CreatorCoin impl: 0x056e4a859558a3975761abD7385506BC4D8a8E60
  HookUpgradeGate: 0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99
  ContentCoinHook deployed!
  ContentCoinHook: 0xA111eB372C90507BDF935278d379fB0B53e2D040
  ContentCoinHook salt: 0x0000000000000000000000000000000000000000000000000000000000002092
  CreatorCoinHook deployed!
  CreatorCoinHook: 0x71F5b2f7F909b9A463918ba9bfC776361fC31040
  CreatorCoinHook salt: 0x000000000000000000000000000000000000000000000000000000000000c583
  New factory impl: 0x10156cbC809Ab21D968B392882cA58685264c591
  === Factory upgraded successfully ===
  deployCreatorCoin selector exists (reverted as expected with bad params)
  Manager: 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2
  WalletFactory: 0xE527DDaC2592FAa45884a0B78E4D377a5D3dF8cc
  === Testing onboard flow ===
  Onboard successful!
  Creator coin: 0xA14d07A5cBDd56b3cE693c3F98a267c549C2E33A
Error: `Unknown0` is above the contract size limit (39555 > 24576).
Error: `Unknown1` is above the contract size limit (29876 > 24576).
Error: `Unknown2` is above the contract size limit (31149 > 24576).
Error: `HooksDeployer` is above the contract size limit (93046 > 24576).
Error: `Unknown6` is above the contract size limit (32284 > 24576).
Do you wish to continue? yes

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:

  [7956617] → new Coin@0x53Eba1e079F885482238EE8bf01C4A9f09DE458f
    ├─ emit Initialized(version: 1)
    ├─ emit Initialized(version: 1)
    └─ ← [Return] 39555 bytes of code

  [6011619] → new CoinV4@0x56186c1e64ca8043DEF78d06Aff222212ea5df71
    ├─ emit Initialized(version: 1)
    └─ ← [Return] 29876 bytes of code

  [6271337] → new CreatorCoin@0x056e4a859558a3975761abD7385506BC4D8a8E60
    ├─ emit Initialized(version: 1)
    ├─ emit Initialized(version: 1)
    └─ ← [Return] 31149 bytes of code

  [601208] → new HookUpgradeGate@0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99
    ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: TestCreatorCoin: [0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519])
    └─ ← [Return] 2861 bytes of code

  [18666160] → new HooksDeployer@0x093Dc47bBd22C27D4e6996bdD34cb7eE7FfbA657
    └─ ← [Return] 93046 bytes of code

  [91146718] HooksDeployer::deployContentCoinHook(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, 0x777777751622c0d3258f214F9DF38E35BF45baF3, [0x492E6456D9528771018DeB9E87ef7750EF184104, 0xAc631556d3d4019C95769033B5E719dD77124BAc], HookUpgradeGate: [0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99])
    ├─ [8458314] → new ContentCoinHook@0xA111eB372C90507BDF935278d379fB0B53e2D040
    │   └─ ← [Return] 41900 bytes of code
    └─ ← [Return] ContentCoinHook: [0xA111eB372C90507BDF935278d379fB0B53e2D040], 0x0000000000000000000000000000000000000000000000000000000000002092

  [494472928] HooksDeployer::deployCreatorCoinHook(0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408, 0x777777751622c0d3258f214F9DF38E35BF45baF3, [0x492E6456D9528771018DeB9E87ef7750EF184104, 0xAc631556d3d4019C95769033B5E719dD77124BAc], HookUpgradeGate: [0x259435d8Df5171c5Cc48B6aF3F8578420be4bc99])
    ├─ [8152776] → new CreatorCoinHook@0x71F5b2f7F909b9A463918ba9bfC776361fC31040
    │   └─ ← [Return] 40375 bytes of code
    └─ ← [Return] CreatorCoinHook: [0x71F5b2f7F909b9A463918ba9bfC776361fC31040], 0x000000000000000000000000000000000000000000000000000000000000c583

  [6491436] → new ZoraFactoryImpl@0x10156cbC809Ab21D968B392882cA58685264c591
    ├─ emit Initialized(version: 18446744073709551615 [1.844e19])
    └─ ← [Return] 32284 bytes of code

  [1381181] → new Manager@0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2
    ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
    └─ ← [Return] 6773 bytes of code

  [499538] → new WalletFactory@0xE527DDaC2592FAa45884a0B78E4D377a5D3dF8cc
    └─ ← [Return] 2380 bytes of code

  [25857] Manager::updateWalletFactory(WalletFactory: [0xE527DDaC2592FAa45884a0B78E4D377a5D3dF8cc])
    └─ ← [Return]

  [472789] Manager::onboard("demo-01", "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "tt")
    ├─ [183088] WalletFactory::createCoinbaseWallet(0x0000000000000000000000000000000000000000)
    │   ├─ [168405] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::createAccount([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1)
    │   │   ├─ [34337] → new <unknown>@0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   │   │   └─ ← [Return] 61 bytes of code
    │   │   ├─ [96868] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad::initialize([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2])
    │   │   │   ├─ [94080] 0x000100abaad02f1cfC8Bbe32bD5a564817339E72::initialize([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2]) [delegatecall]
    │   │   │   │   ├─ emit AddOwner(index: 0, owner: 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2)
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Return]
    │   │   └─ ← [Return] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   ├─ [1552] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::getAddress([0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1) [staticcall]
    │   │   └─ ← [Return] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    │   ├─ emit NewCoinbaseWallet(wallet: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad)
    │   └─ ← [Return] 0x5E07a41245E013Cb7933928f65304E365a71c7Ad
    ├─ emit WalletCreated(wallet: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad)
    ├─ [246620] 0x0Ba958A449701907302e28F5955fa9d16dDC45c3::createSmartWallet([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1)
    │   ├─ [237636] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::createAccount([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1)
    │   │   ├─ [34337] → new <unknown>@0x551173E570B4985D5bb9CADD448A169E0290b337
    │   │   │   └─ ← [Return] 61 bytes of code
    │   │   ├─ [165370] 0x551173E570B4985D5bb9CADD448A169E0290b337::initialize([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2])
    │   │   │   ├─ [165064] 0x000100abaad02f1cfC8Bbe32bD5a564817339E72::initialize([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2]) [delegatecall]
    │   │   │   │   ├─ emit AddOwner(index: 0, owner: 0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad)
    │   │   │   │   ├─ emit AddOwner(index: 1, owner: 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2)
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Return]
    │   │   └─ ← [Return] 0x551173E570B4985D5bb9CADD448A169E0290b337
    │   ├─ [1925] 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a::getAddress([0x0000000000000000000000005e07a41245e013cb7933928f65304e365a71c7ad, 0x000000000000000000000000765574c96e0c83885f1ae9c98d44ce5aaa6457b2], 1) [staticcall]
    │   │   └─ ← [Return] 0x551173E570B4985D5bb9CADD448A169E0290b337
    │   ├─ emit ZoraSmartWalletCreated(param0: 0x551173E570B4985D5bb9CADD448A169E0290b337, param1: 0x5E07a41245E013Cb7933928f65304E365a71c7Ad, param2: [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], param3: 1)
    │   └─ ← [Return] 0x551173E570B4985D5bb9CADD448A169E0290b337
    ├─ emit ZoraAccountCreated(zoraAccount: 0x551173E570B4985D5bb9CADD448A169E0290b337)
    ├─ [5463] 0x777777751622c0d3258f214F9DF38E35BF45baF3::deployCreatorCoin(0x5E07a41245E013Cb7933928f65304E365a71c7Ad, [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x551173E570B4985D5bb9CADD448A169E0290b337, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "demo-01.tt", "demo-01.tt", 0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000001111111111166b7fe7bd91427724b487980afc6900000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001800000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee2d80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000e4840000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000b1a2bc2ec50000, Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], 0x8d2d5259dc6233909fc636eadb3c4e02f648063a9078741f90cd0cdd1356a6d6)
    │   ├─ [452] 0x1702d15066B6F5CcCE94Ca1d9e353D1F073448c4::deployCreatorCoin(0x5E07a41245E013Cb7933928f65304E365a71c7Ad, [0x5E07a41245E013Cb7933928f65304E365a71c7Ad, 0x551173E570B4985D5bb9CADD448A169E0290b337, 0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq", "demo-01.tt", "demo-01.tt", 0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000001111111111166b7fe7bd91427724b487980afc6900000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001800000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee2d80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000e4840000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000b1a2bc2ec50000, Manager: [0x765574C96e0c83885F1AE9C98D44CE5aaA6457B2], 0x8d2d5259dc6233909fc636eadb3c4e02f648063a9078741f90cd0cdd1356a6d6) [delegatecall]
    │   │   └─ ← [Revert] EvmError: Revert
    │   └─ ← [Revert] EvmError: Revert
    └─ ← [Revert] EvmError: Revert

Error: Simulated execution failed.
```