// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {ICoinbaseSmartWalletFactoryMinimal} from "../_i/ICoinbaseSmartWalletFactory.sol";

import {ZoraHelper} from "./ZoraHelper.sol";

contract User is ZoraHelper {

  address public dAppAdmin;
  address public creatorCoin;

  constructor(address _dAppAdmin) {
    dAppAdmin = _dAppAdmin;
  }

  function initZora(
    string memory _uri,
    string memory _username,
    string memory _dappInitials
  ) public returns (address) {
    creatorCoin = initZora(dAppAdmin, _uri, _username, _dappInitials);
    return creatorCoin;
  }




}