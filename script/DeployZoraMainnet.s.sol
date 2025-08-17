// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Manager} from "../src/Manager.sol";
import {WalletFactory} from "../src/WalletFactory.sol";

contract DeployZoraMainnet is Script {

    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIV_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Deploying Manager ===");

        Manager manager = new Manager();

        console.log("Manager deployed to:", address(manager));

        console.log("=== Deploying Wallet Factory ===");
        WalletFactory walletFactory = new WalletFactory(address(manager));
        console.log("Wallet Factory deployed to:", address(walletFactory));

        manager.updateWalletFactory(address(walletFactory));

        console.log("=== Trying onboarding ===");

        manager.onboard(
            "demo-01",
            "ipfs://bafkreidaaysnttv2uq3jotw3ss4txnywiqwoetybhqywzoudgu2r3xhuye",
            "tt"
        );

        console.log("=== Onboarding complete ===");

        vm.stopBroadcast();
    }
}