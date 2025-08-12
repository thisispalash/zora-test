// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23 < 0.9.0;

// import {ICoinbaseSmartWalletFactory} from "@zoralabs/smart-wallet/interfaces/ICoinbaseSmartWalletFactory.sol";
import {ICoinbaseSmartWalletFactoryLike} from "./ICoinbaseSmartWalletFactoryLike.sol";

contract WalletFactory {

  ICoinbaseSmartWalletFactoryLike public constant smartWalletFactory = ICoinbaseSmartWalletFactoryLike(0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a);
  address public manager;

  event NewCoinbaseWallet(address indexed wallet);

  modifier onlyManager() {
    require(msg.sender == manager, "Only manager can call this function");
    _;
  }

  constructor(address _manager) {
    manager = _manager;
  }

  function createCoinbaseWallet(address _user) public onlyManager returns (address) {

    bytes memory managerEncoded = abi.encode(manager);

    if (_user != address(0)) {
      bytes memory userEncoded = abi.encode(_user);
      bytes[] memory multiOwners = new bytes[](2);
      multiOwners[0] = userEncoded;
      multiOwners[1] = managerEncoded;
      return _createCoinbaseWallet(multiOwners);
    }

    bytes[] memory owners = new bytes[](1);
    owners[0] = managerEncoded;

    return _createCoinbaseWallet(owners);
  }

  function _createCoinbaseWallet(bytes[] memory owners) internal returns (address) {

    smartWalletFactory.createAccount(owners, 1);

    address _wallet = smartWalletFactory.getAddress(owners, 1);

    emit NewCoinbaseWallet(_wallet);

    return _wallet;
  }

}