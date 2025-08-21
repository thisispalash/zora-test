// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {CoinConfigurationVersions} from "@zoralabs/coins/libs/CoinConfigurationVersions.sol";

import {IZoraFactoryMinimal} from "../_i/IZoraFactoryMinimal.sol";

abstract contract ZoraCallbacks {

  address constant ZORA_FACTORY = 0x777777751622c0d3258f214F9DF38E35BF45baF3;

  event ExpectedCoinAddress(address indexed expected, address owner, string name, string symbol, string uri);

  /// @dev to be called when first deployed by UserFactory
  function initZora(
    address _dAppAdmin, // this is silly
    string memory _uri,
    string memory _name,
    string memory _symbol,
    bytes memory _poolConfig
  ) internal returns (address creatorCoin) {

    address payoutRecipient = address(this);

    address[] memory owners = new address[](2);
    owners[0] = address(this);
    owners[1] = _dAppAdmin;

    address _platformReferrer = _dAppAdmin;

    // (string memory _name, string memory _symbol) = _createNameAndSymbol(_username, _dAppInitials);

    // bytes memory _poolConfig = _generatePoolConfig(ZORA_TOKEN);

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
    string memory _uri,
    string memory _name,
    string memory _symbol,
    bytes memory _poolConfig
  ) internal returns (address) {

    address _payoutRecipient = address(this);

    address[] memory _owners = new address[](2);
    _owners[0] = address(this);
    _owners[1] = _dAppAdmin;

    address _platformReferrer = _dAppAdmin;

    // (string memory _name, string memory _symbol) = _createNameAndSymbol(_dAppInitials, _counter);

    // bytes memory _poolConfig = _generatePoolConfig(_creatorCoin);

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

}