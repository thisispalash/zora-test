// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {User} from "./user/User.sol";
import {UserFactory} from "./user/UserFactory.sol";

contract Admin {

  address owner;
  address userFactory;
  string dAppInitials;
  uint256 coinCounter;

  mapping(address => bool) public users;
  mapping(address => address) public userToCreatorCoin;
  mapping(address => address) public creatorCoinToUser;

  mapping(uint256 => address) public coinIdToUser;
  mapping(uint256 => address) public coinIdToCoin;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  constructor(string memory _dAppInitials) {
    owner = msg.sender;
    dAppInitials = _dAppInitials;
    coinCounter = 0;
  }

  function setUserFactory(address _userFactory) external onlyOwner {
    userFactory = _userFactory;
  }

  function onboardUser(
    string memory _uri, 
    string memory _username
  ) external onlyOwner returns (address user, address creatorCoin) {

    UserFactory _userFactory = UserFactory(userFactory);
    User _user = User(_userFactory.createUser());

    creatorCoin = _user.initZora(
      _uri,
      _username,
      dAppInitials
    );

    users[address(_user)] = true;
    userToCreatorCoin[address(_user)] = creatorCoin;
    creatorCoinToUser[creatorCoin] = address(_user);

    return (address(_user), creatorCoin);
  }

  function awardCoin(
    address _user,
    string memory _uri
  ) external onlyOwner returns (uint256, address) {

    require(users[_user], "User not found");
    coinCounter++;

    User user_ = User(_user);

    address _contentCoin = user_.createContentCoin(
      _uri,
      dAppInitials,
      coinCounter
    );

    coinIdToUser[coinCounter] = _user;
    coinIdToCoin[coinCounter] = _contentCoin;

    return (coinCounter, _contentCoin);
  }

}