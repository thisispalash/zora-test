// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23 < 0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {WalletFactory} from "./WalletFactory.sol";
import {ZoraAccountManagerImpl} from "@zoralabs/smart-wallet/ZoraAccountManagerImpl.sol";
import {ZoraFactoryImpl} from "@zoralabs/coins/ZoraFactoryImpl.sol";

import {CoinConfigurationVersions} from "@zoralabs/coins/libs/CoinConfigurationVersions.sol";

contract Manager is Ownable {

  ZoraFactoryImpl public constant zoraFactory = ZoraFactoryImpl(0x777777751622c0d3258f214F9DF38E35BF45baF3);
  ZoraAccountManagerImpl public constant zoraAccountManager = ZoraAccountManagerImpl(0x0Ba958A449701907302e28F5955fa9d16dDC45c3);

  WalletFactory public walletFactory;

  mapping(bytes32 name => address wallet) public wallets;
  mapping(address coin => address wallet) public coinOwners;

  event WalletCreated(address indexed wallet);
  event ZoraAccountCreated(address indexed zoraAccount);
  event CreatorCoinCreated(address indexed creatorCoin);
  

  constructor() Ownable(msg.sender) {

  }

  // demo creator coin ipfs ~ bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq
  function onboard(string memory _name, string memory _uri, string memory _dapp) external onlyOwner returns (address) {

    bytes32 nameHash = keccak256(bytes(_name));

    // deploy wallet
    address _wallet = walletFactory.createCoinbaseWallet(address(0));
    emit WalletCreated(_wallet);

    // create zora account
    bytes memory walletEncoded = abi.encode(_wallet);
    bytes memory managerEncoded = abi.encode(address(this));

    bytes[] memory zoraAccountOwners = new bytes[](2);
    zoraAccountOwners[0] = walletEncoded;
    zoraAccountOwners[1] = managerEncoded;

    address _zoraAccount = zoraAccountManager.createSmartWallet(zoraAccountOwners, 1);
    emit ZoraAccountCreated(_zoraAccount);
    
    // deploy creator coin
    bytes memory zoraAccountEncoded = abi.encode(_zoraAccount);

    bytes[] memory creatorCoinOwners = new bytes[](3);
    creatorCoinOwners[0] = walletEncoded;
    creatorCoinOwners[1] = zoraAccountEncoded;
    creatorCoinOwners[2] = managerEncoded;

    (string memory name, string memory symbol) = _createNameAndSymbol(_name, _dapp);

    bytes memory poolConfig = _generatePoolConfig();

    address _creatorCoin = zoraFactory.deployCreatorCoin(
      _wallet,
      creatorCoinOwners,
      _uri,
      name,
      symbol,
      poolConfig,
      address(this),
      abi.encode(name)
    );
    emit CreatorCoinCreated(_creatorCoin);

    return _creatorCoin;
  }

  function createCoin() public onlyOwner returns (address) {

  }

  function updateWalletFactory(address _walletFactory) external onlyOwner {
    walletFactory = WalletFactory(_walletFactory);
  }

  function _createNameAndSymbol(string memory _username, string memory _dapp) internal pure returns (string memory, string memory) {

    string memory name = string(abi.encodePacked(_username, ".", _dapp));
    string memory symbol = string(abi.encodePacked(_username, ".", _dapp));

    return (name, symbol);
  }

  function _generatePoolConfig() internal pure returns (bytes memory) {

    // reference(s):
    // config ~ https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/coins-sdk/src/utils/poolConfigUtils.ts#L37-L53
    // createCoin ~ https://github.com/ourzora/zora-protocol/blob/165ca25aebdee1e0955019fa22986e5a3f9e01f9/packages/coins-sdk/src/actions/createCoin.ts#L58-L75

    uint8 _version = 4;
    address _currency = 0x1111111111166b7FE7bd91427724B487980aFc69; // $ZORA
    int24[] memory _tickLower = new int24[](3);
    _tickLower[0] = -73000;
    _tickLower[1] = -69000;
    _tickLower[2] = -62000;

    int24[] memory _tickUpper = new int24[](3);
    _tickUpper[0] = -58500;
    _tickUpper[1] = -50000;
    _tickUpper[2] = -47500;

    uint16[] memory _numDiscoveryPositions = new uint16[](3);
    _numDiscoveryPositions[0] = 11;
    _numDiscoveryPositions[1] = 11;
    _numDiscoveryPositions[2] = 11;

    uint256[] memory _maxDiscoverySupplyShare = new uint256[](3);
    _maxDiscoverySupplyShare[0] = 0.1 ether; // 1e17
    _maxDiscoverySupplyShare[1] = 0.1 ether; // 1e17
    _maxDiscoverySupplyShare[2] = 0.1 ether; // 1e17

    return CoinConfigurationVersions.encodeDopplerMultiCurveUniV4(
      _currency, 
      _tickLower, 
      _tickUpper, 
      _numDiscoveryPositions, 
      _maxDiscoverySupplyShare
    );
  }

}