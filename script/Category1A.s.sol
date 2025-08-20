// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Admin} from "../src/Admin.sol";
import {UserFactory} from "../src/user/UserFactory.sol";

contract Category1A is Script {

  function run() public {

    console.log("==== Running Category 1A Script ====");
    console.log("---- Hardcoded static poolconfig ----");

    uint256 deployerPrivateKey = vm.envUint("PRIV_KEY");
    address deployer = vm.addr(deployerPrivateKey);

    console.log("Deployer :: ", deployer);

    vm.startBroadcast(deployerPrivateKey);

    console.log("=== Deploying Admin ===");

    Admin admin = new Admin("TT");

    console.log("Admin :: ", address(admin));

    console.log("=== Deploying UserFactory ===");

    UserFactory userFactory = new UserFactory(address(admin));

    console.log("UserFactory :: ", address(userFactory));

    admin.setUserFactory(address(userFactory));

    vm.stopBroadcast();
    

    vm.startBroadcast(deployerPrivateKey);

    console.log("=== Deploying Creator Coin ===");

    string memory creatorIPFS = "ipfs://bafkreibq4pqxkb7nqc6sw6dmzz7fqhtwfch2mhipbd4zuvok2kjjolkgw4";

    (address user, address creatorCoin) = admin.onboardUser(creatorIPFS, "user01");

    console.log("User :: ", user);
    console.log("Creator Coin :: ", creatorCoin);
    console.log("Creator IPFS :: ", creatorIPFS);
    console.log("Creator Name :: ", "user01.TT");

    vm.stopBroadcast();


    vm.startBroadcast(deployerPrivateKey);

    console.log("=== Deploying Content Coin ===");

    string memory contentIPFS = "ipfs://bafkreih5j2hao4wmoahru6bkdpzwhjie6lmdwirzmnouojpbwqrwmuzjny";

    (uint256 coinId, address contentCoin) = admin.awardCoin(user, contentIPFS);

    console.log("Coin ID :: ", coinId);
    console.log("Content Coin :: ", contentCoin);
    console.log("Content IPFS :: ", contentIPFS);
    console.log("Content Name :: ", "TT-00001"); /// @dev should be programmatic, but works for now

    vm.stopBroadcast();

    console.log("==== Category 1A Script complete ====");
  }
}