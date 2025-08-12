// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24 < 0.9.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import {Manager} from "../src/Manager.sol";
import {WalletFactory} from "../src/WalletFactory.sol";

import {ZoraFactoryImpl} from "@zoralabs/coins/ZoraFactoryImpl.sol";
import {CreatorCoin} from "@zoralabs/coins/CreatorCoin.sol";
import {CoinV4} from "@zoralabs/coins/CoinV4.sol";
import {CreatorCoinHook} from "@zoralabs/coins/hooks/CreatorCoinHook.sol";
import {ContentCoinHook} from "@zoralabs/coins/hooks/ContentCoinHook.sol";

import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract TestCreatorCoin is Script {
    // Base Sepolia addresses
    address constant ZORA_FACTORY_PROXY = 0x777777751622c0d3258f214F9DF38E35BF45baF3;
    address constant POOL_MANAGER_V4 = 0xf242cE588b030d0895C51C0730F2368680f80644; // Base Sepolia
    address constant PROTOCOL_REWARDS = 0x7777777F279eba3d3Ad8F4E708545291A6fDBA8B;
    address constant WETH = 0x4200000000000000000000000000000000000006;

    address constant COIN_IMPL = 0xbBCaf6099bd2a42d61e4ECE2eAfE7C42A17eC119;
    address constant COIN_V4_IMPL = 0xfE55eF381A32fE9B8fE287a5CEB0A05A9873a018;

    Manager manager;
    WalletFactory walletFactory;
    
    function run() external {
        console2.log("=== Upgrading Zora Factory on Base Sepolia Fork ===");
        
        // 1. Get the current proxy admin
        address proxyAdmin = getProxyAdmin(ZORA_FACTORY_PROXY);
        console2.log("Proxy admin:", proxyAdmin);
        
        // 2. Get proxy admin owner
        address adminOwner = ProxyAdmin(proxyAdmin).owner();
        console2.log("Admin owner:", adminOwner);
        
        // 3. Deploy new implementation contracts
        vm.startBroadcast();
        
        // Deploy CreatorCoin implementation
        CreatorCoin creatorCoinImpl = new CreatorCoin(
            address(0),  // protocolRewardRecipient
            PROTOCOL_REWARDS,  // protocolRewards 
            POOL_MANAGER_V4,   // poolManager
            adminOwner         // airlock
        );
        console2.log("CreatorCoin impl:", address(creatorCoinImpl));
        
        // Deploy CreatorCoinHook
        address[] memory trustedSenders = new address[](3);
        trustedSenders[0] = ZORA_FACTORY_PROXY;
        trustedSenders[1] = address(this);
        trustedSenders[2] = 0x66E9e64D743B7678331B1617Bf67b238897E04F8; // personal dev wallet
        
        CreatorCoinHook creatorCoinHook = new CreatorCoinHook(
            POOL_MANAGER_V4,
            ZORA_FACTORY_PROXY, // coinVersionLookup (factory acts as this)
            trustedSenders,
            address(0) // upgradeGate - use zero for now
        );
        console2.log("CreatorCoinHook:", address(creatorCoinHook));

        // Deploy ContentCoinHook implementation
        ContentCoinHook contentCoinHook = new ContentCoinHook(
            POOL_MANAGER_V4,
            ZORA_FACTORY_PROXY, // coinVersionLookup (factory acts as this)
            trustedSenders,
            address(0) // upgradeGate - use zero for now
        );
        console2.log("ContentCoinHook:", address(contentCoinHook));
        
        vm.stopBroadcast();
        
        // 4. Deploy new ZoraFactoryImpl with all the required constructor args
        vm.startBroadcast();
        
        ZoraFactoryImpl newFactoryImpl = new ZoraFactoryImpl(
            address(COIN_IMPL),         // coinImpl (V3)
            address(COIN_V4_IMPL),      // coinV4Impl 
            address(creatorCoinImpl),   // creatorCoinImpl
            address(creatorCoinHook),   // contentCoinHook
            address(creatorCoinHook)    // creatorCoinHook
        );
        console2.log("New factory impl:", address(newFactoryImpl));
        
        vm.stopBroadcast();
        
        // 5. Upgrade the proxy (impersonate admin owner)
        vm.startPrank(adminOwner);
        ProxyAdmin(proxyAdmin).upgrade(
            ITransparentUpgradeableProxy(ZORA_FACTORY_PROXY),
            address(newFactoryImpl)
        );
        vm.stopPrank();
        
        console2.log("=== Factory upgraded successfully ===");
        
        // 6. Verify deployCreatorCoin exists now
        ZoraFactoryImpl factory = ZoraFactoryImpl(ZORA_FACTORY_PROXY);
        
        // Try to call the selector to verify it exists
        try factory.deployCreatorCoin(
            address(0x1),
            new address[](0), 
            "",
            "",
            "", 
            hex"00",
            address(0),
            bytes32(0)
        ) {
            console2.log("ERROR: Should have reverted with invalid params");
        } catch {
            console2.log("deployCreatorCoin selector exists (reverted as expected with bad params)");
        }
        
        // 7. Deploy your contracts
        vm.startBroadcast();
        
        walletFactory = new WalletFactory();
        console2.log("WalletFactory:", address(walletFactory));
        
        manager = new Manager();
        console2.log("Manager:", address(manager));
        
        // Set wallet factory on manager
        manager.updateWalletFactory(address(walletFactory));
        
        vm.stopBroadcast();
        
        // 8. Test onboard flow
        testOnboard();
    }
    
    function testOnboard() internal {
        console2.log("=== Testing onboard flow ===");
        
        vm.startBroadcast();
        
        try manager.onboard(
            "demo-01",
            "ipfs://bafkreibwhkbceqbgydntjhzz3dz5d2c7b3wwkpzr5gqfdx56dermh6bomq",
            "tt"
        ) returns (address creatorCoin) {
            console2.log("Onboard successful!");
            console2.log("Creator coin:", creatorCoin);
        } catch Error(string memory reason) {
            console2.log("Onboard failed:");
            console2.log(reason);
        } catch (bytes memory data) {
            console2.log("Onboard failed with data:");
            console2.logBytes(data);
        }
        
        vm.stopBroadcast();
    }
    
    function getProxyAdmin(address proxy) internal view returns (address) {
        // Standard storage slot for proxy admin in TransparentUpgradeableProxy
        // bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
        bytes32 adminSlot = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
        return address(uint160(uint256(vm.load(proxy, adminSlot))));
    }
}

