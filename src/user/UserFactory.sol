// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {User} from "./User.sol";

contract UserFactory {

  address immutable dAppAdmin;
  mapping(address => bool) public users;

  modifier onlyDAppAdmin() {
    require(msg.sender == dAppAdmin, "Only dAppAdmin can call this function");
    _;
  }

  constructor(address _dAppAdmin) {
    dAppAdmin = _dAppAdmin;
  }

  function createUser() external onlyDAppAdmin returns (address) {
    User user = new User(dAppAdmin);
    users[address(user)] = true;
    return address(user);
  }

  function isUser(address _user) external view returns (bool) {
    return users[_user];
  }
  
}