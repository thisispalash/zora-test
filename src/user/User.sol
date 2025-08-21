// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {ICoinbaseSmartWalletFactoryMinimal} from "../_i/ICoinbaseSmartWalletFactory.sol";

import {ZoraCallbacks} from "./ZoraCallbacks.sol";

contract User is ZoraCallbacks {

  address public dAppAdmin;
  address public creatorCoin;
  address[] public coins;

  mapping(address => string) public coinToId;

  modifier onlyDAppAdmin() {
    require(msg.sender == dAppAdmin, "Only dAppAdmin can call this function");
    _;
  }

  constructor(address _dAppAdmin) {
    dAppAdmin = _dAppAdmin;
  }

  function initZora(
    string memory _uri,
    string memory _name,
    string memory _symbol,
    bytes memory _poolConfig
  ) public onlyDAppAdmin returns (address) {
    creatorCoin = initZora(dAppAdmin, _uri, _name, _symbol, _poolConfig);
    return creatorCoin;
  }

  function createContentCoin(
    string memory _uri,
    string memory _name,
    string memory _symbol,
    bytes memory _poolConfig
  ) public onlyDAppAdmin returns (address) {
    
    require(creatorCoin != address(0), "Creator coin not initialized");
    
    address _contentCoin = createContentCoin(dAppAdmin, _uri, _name, _symbol, _poolConfig);
    coins.push(_contentCoin);
    coinToId[_contentCoin] = _name;
    return _contentCoin;
  }

}