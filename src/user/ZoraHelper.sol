// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {CoinConfigurationVersions} from "@zoralabs/coins/libs/CoinConfigurationVersions.sol";

import {IZoraFactoryMinimal} from "../_i/IZoraFactoryMinimal.sol";

abstract contract ZoraHelper {

  address constant ZORA_FACTORY = 0x777777751622c0d3258f214F9DF38E35BF45baF3;
  address constant ZORA_TOKEN = 0x1111111111166b7FE7bd91427724B487980aFc69;

  event ExpectedCoinAddress(address indexed expected, address owner, string name, string symbol, string uri);

  /// @dev to be called when first deployed by UserFactory
  function initZora(
    address _dAppAdmin, // this is silly
    string memory _uri,
    string memory _username,
    string memory _dappInitials
  ) internal returns (address creatorCoin) {

    address payoutRecipient = address(this);

    address[] memory owners = new address[](2);
    owners[0] = address(this);
    owners[1] = _dAppAdmin;

    address platformReferrer = address(this);

    (string memory _name, string memory _symbol) = _createNameAndSymbol(_username, _dappInitials);

    bytes memory _poolConfig = _generatePoolConfig();

    IZoraFactoryMinimal zoraFactory = IZoraFactoryMinimal(ZORA_FACTORY);

    address _expected = zoraFactory.coinAddress(
      address(this),
      _name,
      _symbol,
      _poolConfig,
      platformReferrer,
      bytes32(0)
    );

    emit ExpectedCoinAddress(_expected, address(this), _name, _symbol, _uri);

    address _actual = zoraFactory.deployCreatorCoin(
      payoutRecipient, 
      owners, 
      _uri,
      _name,
      _symbol,
      _poolConfig,
      platformReferrer,
      bytes32(0)
    );

    return _actual;
  }


  function _createNameAndSymbol(
    string memory _username, 
    string memory _dappInitials
  ) internal pure returns (string memory name, string memory symbol) {

    name = string(abi.encodePacked(_username, ".", _dappInitials));
    symbol = string(abi.encodePacked(_username, ".", _dappInitials));

  }

  function _generatePoolConfig() internal pure returns (bytes memory) {

    address _currency = ZORA_TOKEN;

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