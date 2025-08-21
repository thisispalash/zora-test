// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {User} from "./user/User.sol";
import {UserFactory} from "./user/UserFactory.sol";

import {ZoraHelper} from "./ZoraHelper.sol";

contract Admin is ZoraHelper {

  address owner;
  address userFactory;
  uint256 coinCounter;

  mapping(address => bool) public users;
  mapping(address => address) public userToCreatorCoin;
  mapping(address => address) public creatorCoinToUser;

  mapping(uint256 => address) public coinIdToUser;
  mapping(uint256 => address) public coinIdToCoin;

  event UserCreated(address indexed user, string username);
  event CreatorCoinCreated(address indexed creatorCoin, string name, string symbol, string uri);
  event ContentCoinCreated(address indexed contentCoin, address indexed user, uint256 coinId, string name, string symbol, string uri);

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  constructor(string memory _dAppInitials) ZoraHelper(_dAppInitials) {
    owner = msg.sender;
    coinCounter = 0;
  }

  function setUserFactory(address _userFactory) external onlyOwner {
    userFactory = _userFactory;
  }

  function onboardUser(
    string memory _uri, 
    string memory _username
  ) external onlyOwner returns (address user, address creatorCoin) {

    /// Deploy User contract
    UserFactory _userFactory = UserFactory(userFactory);
    User _user = User(_userFactory.createUser());

    emit UserCreated(address(_user), _username);

    /// Create creator coin for the user
    (string memory _name, string memory _symbol) = _generateCreatorCoinNameAndSymbol(_username);
    bytes memory _poolConfig = _generateStaticPoolConfig(ZORA_TOKEN);

    creatorCoin = _user.initZora(_uri, _name, _symbol, _poolConfig);

    emit CreatorCoinCreated(creatorCoin, _name, _symbol, _uri);

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

    (string memory _name, string memory _symbol) = _generateContentCoinNameAndSymbol(coinCounter);
    bytes memory _poolConfig = _generateStaticPoolConfig(user_.creatorCoin());

    address _contentCoin = user_.createContentCoin(_uri, _name, _symbol, _poolConfig);

    emit ContentCoinCreated(_contentCoin, _user, coinCounter, _name, _symbol, _uri);

    coinIdToUser[coinCounter] = _user;
    coinIdToCoin[coinCounter] = _contentCoin;

    return (coinCounter, _contentCoin);
  }

}