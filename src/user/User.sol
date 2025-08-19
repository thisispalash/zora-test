// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {ICoinbaseSmartWalletFactoryMinimal} from "../_i/ICoinbaseSmartWalletFactory.sol";

import {ZoraHelper} from "./ZoraHelper.sol";

contract User is ZoraHelper {

  address public dAppAdmin;
  address public creatorCoin;
  address[] public coins;

  mapping(address => uint256) public coinToId;

  modifier onlyDAppAdmin() {
    require(msg.sender == dAppAdmin, "Only dAppAdmin can call this function");
    _;
  }

  constructor(address _dAppAdmin) {
    dAppAdmin = _dAppAdmin;
  }

  function initZora(
    string memory _uri,
    string memory _username,
    string memory _dAppInitials
  ) public onlyDAppAdmin returns (address) {
    creatorCoin = initZora(dAppAdmin, _uri, _username, _dAppInitials);
    return creatorCoin;
  }

  function createContentCoin(
    string memory _uri,
    string memory _dAppInitials,
    uint256 _counter
  ) public onlyDAppAdmin returns (address) {
    require(creatorCoin != address(0), "Creator coin not initialized");
    address _contentCoin = createContentCoin(dAppAdmin, creatorCoin, _uri, _dAppInitials, _counter);
    coins.push(_contentCoin);
    coinToId[_contentCoin] = _counter;
    return _contentCoin;
  }

}