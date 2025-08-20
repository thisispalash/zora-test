// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Admin} from "../../src/Admin.sol";
import {UserFactory} from "../../src/user/UserFactory.sol";

/**
 * @title StaticPoolConfigTest
 * @notice Test for category 1a
 * @notice This test should run on base mainnet (or a fork)
 * `forge test --match-contract TestContentCoin --fork-url https://mainnet.base.org`
 */
contract TestCreatorCoin is Test {

  Admin admin;
  UserFactory userFactory;

  address user;
  address creatorCoin;

  function setUp() public {

    console.log("==== Starting setup ====");

    vm.startBroadcast();

    admin = new Admin("TT");
    userFactory = new UserFactory(address(admin));

    console.log("admin :: ", address(admin));
    console.log("userFactory :: ", address(userFactory));

    admin.setUserFactory(address(userFactory));

    vm.stopBroadcast();

    console.log("==== Setup complete ====");

  }

  function test_creator() public {

    console.log("==== Starting test_creator ====");

    string memory creatorIPFS = "ipfs://bafkreibq4pqxkb7nqc6sw6dmzz7fqhtwfch2mhipbd4zuvok2kjjolkgw4";

    vm.startBroadcast();

    (user, creatorCoin) = admin.onboardUser(creatorIPFS, "user01");

    console.log("user :: ", user);
    console.log("creatorCoin :: ", creatorCoin);
    console.log("creatorIPFS :: ", creatorIPFS);
    console.log("creatorName :: ", "user01.TT");

    vm.stopBroadcast();

    console.log("==== test_creator complete ====");

  }

}