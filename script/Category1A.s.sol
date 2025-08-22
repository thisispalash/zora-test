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


    /** Setup Protocol Contracts */

    console.log("=== Setup Admin and UserFactory ===");
    
    vm.startBroadcast(deployerPrivateKey);

    Admin admin = new Admin("ZT"); // Zora Test
    UserFactory userFactory = new UserFactory(address(admin));

    console.log("Admin :: ", address(admin));
    console.log("UserFactory :: ", address(userFactory));

    admin.setUserFactory(address(userFactory));

    vm.stopBroadcast();
    

    /** Onboarding Users */

    console.log("=== Create the two users ===");

    vm.startBroadcast(deployerPrivateKey);

    string memory gokuIPFS = "ipfs://bafkreibzd3meziylhx26cdarwtvgmbjh6lxt3ecdkyfvw4kbx36wccmmm4";
    string memory vegetaIPFS = "ipfs://bafkreibvdwmqdcvy3fjvirj63rh72boo3jwgo4jffiimydi5djlefjblt4";

    (address user01, address creatorCoin01) = admin.onboardUser(gokuIPFS, "goku");
    (address user02, address creatorCoin02) = admin.onboardUser(vegetaIPFS, "vegeta");

    console.log("--- Goku ---");
    console.log("User :: ", user01);
    console.log("Creator Coin :: ", creatorCoin01);
    console.log("Creator IPFS :: ", gokuIPFS);
    console.log("Creator Name :: ", "goku.ZT");

    console.log("--- Vegeta ---");
    console.log("User :: ", user02);
    console.log("Creator Coin :: ", creatorCoin02);
    console.log("Creator IPFS :: ", vegetaIPFS);
    console.log("Creator Name :: ", "vegeta.ZT");

    vm.stopBroadcast();


    /** Awarding Content Coins to Users */
    
    console.log("=== Award Content Coins to Users ===");

    vm.startBroadcast(deployerPrivateKey);

    string memory content01IPFS = "ipfs://bafkreiglz4kleybyya5itsicek3nkpvzo5dz7jc3zc5j5xim7wkqewhc6a";
    string memory content02IPFS = "ipfs://bafkreihmbk7jb2ktw5oq4yios3lz3ojr564olawfiq4unn3xsjlbdi7x54";

    (uint256 coinId01, address contentCoin01) = admin.awardCoin(user01, content01IPFS);
    (uint256 coinId02, address contentCoin02) = admin.awardCoin(user02, content02IPFS);

    console.log("--- Content 01 ---");
    console.log("Coin ID :: ", coinId01);
    console.log("Awarded to ::", user01);
    console.log("Content Coin :: ", contentCoin01);
    console.log("Content IPFS :: ", content01IPFS);
    console.log("Content Name :: ", "ZT-00001"); // @dev should be programmatic, but works for now

    console.log("--- Content 02 ---");
    console.log("Coin ID :: ", coinId02);
    console.log("Awarded to ::", user02);
    console.log("Content Coin :: ", contentCoin02);
    console.log("Content IPFS :: ", content02IPFS);
    console.log("Content Name :: ", "ZT-00002"); // @dev should be programmatic, but works for now

    vm.stopBroadcast();

    console.log("==== Category 1A Script complete ====");
  }
}