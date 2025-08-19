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
    string memory _dAppInitials
  ) internal returns (address creatorCoin) {

    address payoutRecipient = address(this);

    address[] memory owners = new address[](2);
    owners[0] = address(this);
    owners[1] = _dAppAdmin;

    address _platformReferrer = _dAppAdmin;

    (string memory _name, string memory _symbol) = _createNameAndSymbol(_username, _dAppInitials);

    bytes memory _poolConfig = _generatePoolConfig(ZORA_TOKEN);

    IZoraFactoryMinimal zoraFactory = IZoraFactoryMinimal(ZORA_FACTORY);

    address _expected = zoraFactory.coinAddress(
      address(this),
      _name,
      _symbol,
      _poolConfig,
      _platformReferrer,
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
      _platformReferrer,
      bytes32(0)
    );

    return _actual;
  }


  function createContentCoin(
    address _dAppAdmin,
    address _creatorCoin, // this is also silly
    string memory _uri,
    string memory _dAppInitials,
    uint256 _counter // Coin number for the dApp
  ) internal returns (address) {

    address _payoutRecipient = address(this);

    address[] memory _owners = new address[](2);
    _owners[0] = address(this);
    _owners[1] = _dAppAdmin;

    address _platformReferrer = _dAppAdmin;

    (string memory _name, string memory _symbol) = _createNameAndSymbol(_dAppInitials, _counter);

    bytes memory _poolConfig = _generatePoolConfig(_creatorCoin);

    IZoraFactoryMinimal zoraFactory = IZoraFactoryMinimal(ZORA_FACTORY);

    address _expected = zoraFactory.coinAddress(
      address(this),
      _name,
      _symbol,
      _poolConfig,
      _platformReferrer,
      bytes32(0)
    );

    emit ExpectedCoinAddress(_expected, address(this), _name, _symbol, _uri);

    (address _actual, ) = zoraFactory.deploy(
      _payoutRecipient,
      _owners,
      _uri,
      _name,
      _symbol,
      _poolConfig,
      _platformReferrer,
      address(0),
      bytes(""),
      bytes32(0)
    );

    return _actual;
  }

  /// @dev create a name and symbol for the creator coin
  function _createNameAndSymbol(
    string memory _username, 
    string memory _dAppInitials
  ) internal pure returns (string memory name, string memory symbol) {

    name = string(abi.encodePacked(_username, ".", _dAppInitials));
    symbol = string(abi.encodePacked(_username, ".", _dAppInitials));

  }

  /// @dev create a name and symbol for the content coin
  function _createNameAndSymbol(
    string memory _dAppInitials,
    uint256 _counter
  ) internal pure returns (string memory name, string memory symbol) {

    uint8 _i = 0;

    /// @dev count the number of digits in the counter
    while (_counter > 0) {
      _i++;
      _counter /= 10;
    }
    
    require(_i <= 5, "Max number of coins is 99999");

    /// @dev pad the counter with zeros to 5 digits
    string memory _toString = string("");
    for (_i = 5 - _i; _i > 0; _i--) {
      _toString = string(abi.encodePacked(_toString, "0"));
    }

    name = string(abi.encodePacked(_dAppInitials, "-", _toString));
    symbol = string(abi.encodePacked(_dAppInitials, "-", _toString));
  }

  function _generatePoolConfig(address _currency) internal pure returns (bytes memory) {

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