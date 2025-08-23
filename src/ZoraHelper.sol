// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {CoinConfigurationVersions} from "@zoralabs/coins/libs/CoinConfigurationVersions.sol";

abstract contract ZoraHelper {

  address constant ZORA_TOKEN = 0x1111111111166b7FE7bd91427724B487980aFc69;
  
  string dAppInitials;

  constructor(string memory _dAppInitials) {
    dAppInitials = _dAppInitials;
  }

  /// @dev create a name and symbol for the creator coin
  /// name, symbol: <username>.<dAppInitials>
  function _generateCreatorCoinNameAndSymbol(
    string memory _username
  ) internal view returns (string memory name, string memory symbol) {

    name = string(abi.encodePacked(_username, ".", dAppInitials));
    symbol = string(abi.encodePacked(_username, ".", dAppInitials));

  }

  /// @dev create a name and symbol for the content coin
  /// name, symbol: <dAppInitials>-<counter> (5 digits)
  function _generateContentCoinNameAndSymbol(
    uint256 _counter
  ) internal view returns (string memory name, string memory symbol) {

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
    _toString = string(abi.encodePacked(_toString, _counter)); /// @dev this is wrong, need conversion

    name = string(abi.encodePacked(dAppInitials, "-", _toString));
    symbol = string(abi.encodePacked(dAppInitials, "-", _toString));
  }

  function _generateStaticPoolConfig(address _currency) internal pure returns (bytes memory) {

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