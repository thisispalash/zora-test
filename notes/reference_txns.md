# Reference Txns


## Existing Account

| key | value | link |
| :---: | :---: | :---: |
| Profile | `khaalidimaag` | [zora](https://zora.co/@khaalidimaag) |
| Smart Wallet | `0x9E8Bb57FA5154a83cF385a101BD0450f16ef6361` | [basescan](https://basescan.org/address/0x9E8Bb57FA5154a83cF385a101BD0450f16ef6361) |
| Creator Coin | `0x089A2476A94efa119f1623177d016fF7a851A970` | [basescan](https://basescan.org/address/0x089A2476A94efa119f1623177d016fF7a851A970) |
| Privy EOA | `0xcb952d3BeA0D7018EE21dBA7BCeA7EC31bbFdF92` | [basescan](https://basescan.org/address/0xcb952d3BeA0D7018EE21dBA7BCeA7EC31bbFdF92) |
| Personal EOA | `0x9378Bc37A3d5668AdB1377dF6c2F8e23A95bcDDe` | [basescan](https://basescan.org/address/0x9378Bc37A3d5668AdB1377dF6c2F8e23A95bcDDe) | 
| Coin | `0x6d44b310c6b8bebfbc55c19cfa70b3a04ac8bf02` | [basescan](https://basescan.org/address/0x6d44b310c6b8bebfbc55c19cfa70b3a04ac8bf02) |

### On Signup
> Account Creation ~ [tx](https://basescan.org/tx/0x2be437ef2d497cb8da9108f072fd022d863612ddc887b553cb07043fd6fa9c07)

[`ZoraAccountManager.createSmartWallet`](https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/smart-wallet/src/ZoraAccountManagerImpl.sol#L22-L36)

**decoded input**

| variable | type | value |
| :---: | :---: | :---: |
| encodedOwners |	bytes[] | `0x000000000000000000000000cb952d3bea0d7018ee21dba7bcea7ec31bbfdf92` `0x0000000000000000000000009378bc37a3d5668adb1377df6c2f8e23a95bcdde` |
| nonce |	uint256 | 1 |


### Creator Coin
> [aa-tx](https://basescan.org/tx/0x03c9cee0ad90f50d939fa7e8749f832ed655e06a42e71b2bcf1371a60924d42c)

[`ZoraFactory.deployCreatorCoin`](https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/coins/src/ZoraFactoryImpl.sol#L72-L116)

**decoded input** (final) ~ [basescan](https://basescan.org/inputdatadecoder?tx=0x03c9cee0ad90f50d939fa7e8749f832ed655e06a42e71b2bcf1371a60924d42c)


| variable | type | value |
| :---: | :---: | --- |
| payoutRecipient | address | `0x9E8Bb57FA5154a83cF385a101BD0450f16ef6361` |
| owners | address[] | `0x9E8Bb57FA5154a83cF385a101BD0450f16ef6361` `0xcb952d3BeA0D7018EE21dBA7BCeA7EC31bbFdF92` `0x9378Bc37A3d5668AdB1377dF6c2F8e23A95bcDDe` |
| uri | string | ipfs://bafybeiebby5l7fouwxboc2hjg3uvh5kmyjhg54fpka52p3xcdrblaymmmu |
| name | string | khaalidimaag |
| symbol | string | khaalidimaag |
| poolConfig | bytes | `0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000001111111111166b7fe7bd91427724b487980afc6900000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000003fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffea070fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffedef0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0dd00000000000000000000000000000000000000000000000000000000000000003ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b7cfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffefa48ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff34e00000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000b1a2bc2ec50000000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000000000000000000000000000016345785d8a0000` |
| platformReferrer | address | `0x0000000000000000000000000000000000000000` |
| coinSalt | bytes32 | `0x0000000000000000000000000000000000000000000000000000000000000000` |

_and poolConfig_

```
(uint8 version, address currency, int24[] tickLower, int24[] tickUpper, uint16[] numDiscoveryPositions, uint256[] maxDiscoverySupplyShare)

4
0x1111111111166b7FE7bd91427724B487980aFc69 -> $ZORA
[-90000 [-9e4], -74000 [-7.4e4], -62000 [-6.2e4]]
[-58500 [-5.85e4], -67000 [-6.7e4], -52000 [-5.2e4]]
[11, 11, 11]
[50000000000000000 [5e16], 100000000000000000 [1e17], 100000000000000000 [1e17]]
```

decoded in [`CoinDopplerMultiCurve.setupPool`](https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/coins/src/libs/CoinDopplerMultiCurve.sol#L30-L49).

## Existing Account 2
> Older

| key | value | link |
| :---: | :---: | :---: |
| Profile | `theprimefibber` | [zora](https://zora.co/@theprimefibber) |
| Smart Wallet | `0x00aA4187Fdc539BBDb5e0b7438398198b9f73f76` | [basescan](https://basescan.org/address/0x00aA4187Fdc539BBDb5e0b7438398198b9f73f76) |
| Creator Coin | `0x53a082fa2a86535ca524e7977ce0fa59d8897578` | [basescan](https://basescan.org/address/0x53a082fa2a86535ca524e7977ce0fa59d8897578) |
| Privy EOA | `0x533DB971eaC0304d91c5d1D48E3Fb3e6d5BBf4ab` | [basescan](https://basescan.org/address/0x533DB971eaC0304d91c5d1D48E3Fb3e6d5BBf4ab) |
| Personal EOA | `0x96e03e38aD4B5EF728f4C5F305eddBB509B652d0` | [basescan](https://basescan.org/address/0x96e03e38aD4B5EF728f4C5F305eddBB509B652d0) | 


### On Signup
> Account Creation ~ [tx](https://basescan.org/tx/https://basescan.org/tx/0x8a0d1822786c7c335e9e6e0891c3ca952b042b059fa07c6e90680b12e5114f64)

[`ZoraAccountManager.createSmartWallet`](https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/smart-wallet/src/ZoraAccountManagerImpl.sol#L22-L36)

**decoded input**

| variable | type | value |
| :---: | :---: | :---: |
| encodedOwners |	bytes[] | `0x000000000000000000000000533db971eac0304d91c5d1d48e3fb3e6d5bbf4ab` `0x00000000000000000000000096e03e38ad4b5ef728f4c5f305eddbb509b652d0` |
| nonce |	uint256 | 1 |


### Creator Coin
> [aa-tx](https://basescan.org/tx/0xb944b7d9ca752a08f822404a126278ae64ef732890e6e8de0a14ac9205cfc40a)

[`ZoraFactory.deployCreatorCoin`](https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/coins/src/ZoraFactoryImpl.sol#L72-L116)

**decoded input** (final) ~ [basescan](https://basescan.org/inputdatadecoder?tx=0xb944b7d9ca752a08f822404a126278ae64ef732890e6e8de0a14ac9205cfc40a)

| variable | type | value |
| :---: | :---: | --- |
| payoutRecipient | address | `0x96e03e38aD4B5EF728f4C5F305eddBB509B652d0` |
| owners | address[] | `0x00aA4187Fdc539BBDb5e0b7438398198b9f73f76` `0x533DB971eaC0304d91c5d1D48E3Fb3e6d5BBf4ab` `0x96e03e38aD4B5EF728f4C5F305eddBB509B652d0` |
| uri | string | ipfs://bafybeibl4hk5xepc6w7j2eecls2ybz7jsjkf6a4tpj4cqjppnngrwsrvue |
| name | string | theprimefibber |
| symbol | string | theprimefibber |
| poolConfig | bytes | `0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000001111111111166b7fe7bd91427724b487980afc6900000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000003fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee2d8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef278ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0dd00000000000000000000000000000000000000000000000000000000000000003ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1b7cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff3cb0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff46740000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000b0000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000000000000000000000000000016345785d8a000000000000000000000000000000000000000000000000000000b1a2bc2ec50000` |
| platformReferrer | address | `0x0000000000000000000000000000000000000000` |
| coinSalt | bytes32 | `0x0000000000000000000000000000000000000000000000000000000000000000` |

_and poolConfig_

```
(uint8 version, address currency, int24[] tickLower, int24[] tickUpper, uint16[] numDiscoveryPositions, uint256[] maxDiscoverySupplyShare)

4
0x1111111111166b7FE7bd91427724B487980aFc69
[-73000 [-7.3e4], -69000 [-6.9e4], -62000 [-6.2e4]]
[-58500 [-5.85e4], -50000 [-5e4], -47500 [-4.75e4]]
[11, 11, 11]
[100000000000000000 [1e17], 100000000000000000 [1e17], 50000000000000000 [5e16]]
```

decoded in [`CoinDopplerMultiCurve.setupPool`](https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/coins/src/libs/CoinDopplerMultiCurve.sol#L30-L49).
