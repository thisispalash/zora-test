// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24 < 0.9.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import {Manager} from "../src/Manager.sol";
import {WalletFactory} from "../src/WalletFactory.sol";

import {ZoraFactoryImpl} from "@zoralabs/coins/ZoraFactoryImpl.sol";
import {CreatorCoin} from "@zoralabs/coins/CreatorCoin.sol";
import {Coin} from "@zoralabs/coins/Coin.sol";
import {CoinV4} from "@zoralabs/coins/CoinV4.sol";
import {CreatorCoinHook} from "@zoralabs/coins/hooks/CreatorCoinHook.sol";
import {ContentCoinHook} from "@zoralabs/coins/hooks/ContentCoinHook.sol";
import {HookUpgradeGate} from "@zoralabs/coins/hooks/HookUpgradeGate.sol";
import {HooksDeployment} from "@zoralabs/coins/libs/HooksDeployment.sol";

import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IDeployedCoinVersionLookup} from "@zoralabs/coins/interfaces/IDeployedCoinVersionLookup.sol";
import {IHooksUpgradeGate} from "@zoralabs/coins/interfaces/IHooksUpgradeGate.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @notice This script upgrades the Zora Factory on Base Sepolia Fork and attempts to onboard a creator coin.
 * 
 * To run,
 * $ anvil --fork-url https://sepolia.base.org --chain-id 84532 --port 8545
 * 
 * $ forge script script/TestCreatorCoin.s.sol:TestCreatorCoin --rpc-url http://localhost:8545 --private-key <PRIVATE_KEY> --broadcast -vv
 * 
 */
contract TestCreatorCoin is Script {
    // Base Sepolia addresses
    address constant ZORA_FACTORY_PROXY = 0x777777751622c0d3258f214F9DF38E35BF45baF3;
    address constant PROTOCOL_REWARDS = 0x7777777F279eba3d3Ad8F4E708545291A6fDBA8B;
    address constant AIRLOCK = 0xa24E35a5d71d02a59b41E7c93567626302da1958; // Airlock?
    
    address constant WETH = 0x4200000000000000000000000000000000000006;
    address constant ZORA = 0x1111111111166b7FE7bd91427724B487980aFc69;

    address constant V3_FACTORY = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // Uniswap V3 Factory
    address constant V3_SWAP_ROUTER = 0x94cC0AaC535CCDB3C01d6787D6413C739ae12bc4; // Uniswap V3 SwapRouter02
    address constant POOL_MANAGER = 0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408; // Uniswap V4 PoolManager
    address constant UNIVERSAL_ROUTER = 0x492E6456D9528771018DeB9E87ef7750EF184104; // Uniswap V4 Universal Router
    address constant POSITION_MANAGER = 0xAc631556d3d4019C95769033B5E719dD77124BAc; // Uniswap V4 PositionManager

    Manager manager;
    WalletFactory walletFactory;
    
    function run() external {
        console2.log("=== Upgrading Zora Factory on Base Sepolia Fork ===");
        
        // 1. Get proxy admin owner
        address adminOwner = Ownable(ZORA_FACTORY_PROXY).owner();
        console2.log("Admin owner:", adminOwner);
        
        // 2. Deploy new implementation contracts
        vm.startBroadcast();

        Coin coinImpl = new Coin(
            address(this),               // protocolRewardRecipient
            address(PROTOCOL_REWARDS),   // protocolRewards 
            address(WETH),               // WETH
            address(V3_FACTORY),         // v3Factory
            address(V3_SWAP_ROUTER),     // swapRouter
            address(AIRLOCK)             // airlock
        );
        console2.log("Coin impl:", address(coinImpl));


        CoinV4 coinV4Impl = new CoinV4(
            address(this),               // protocolRewardRecipient
            address(PROTOCOL_REWARDS),   // protocolRewards 
            IPoolManager(POOL_MANAGER),  // poolManager
            address(AIRLOCK)             // airlock
        );
        console2.log("CoinV4 impl:", address(coinV4Impl));
        
        CreatorCoin creatorCoinImpl = new CreatorCoin(
            address(this),               // protocolRewardRecipient
            address(PROTOCOL_REWARDS),   // protocolRewards 
            IPoolManager(POOL_MANAGER),  // poolManager
            address(AIRLOCK)             // airlock
        );
        console2.log("CreatorCoin impl:", address(creatorCoinImpl));

        HookUpgradeGate hookUpgradeGate = new HookUpgradeGate(
            address(this)
        );
        console2.log("HookUpgradeGate:", address(hookUpgradeGate));

        address[] memory trustedSenders = new address[](2);
        trustedSenders[0] = UNIVERSAL_ROUTER;
        trustedSenders[1] = POSITION_MANAGER;

        /// @dev commented section fails due to incompitable deployer address (this vs library)

        // (, bytes32 contentCoinHookSalt) = HooksDeployment.mineForContentCoinSalt(
        //     address(this),
        //     address(POOL_MANAGER),
        //     address(ZORA_FACTORY_PROXY),
        //     trustedSenders,
        //     address(hookUpgradeGate)
        // );
        // console2.log("ContentCoinHook salt:", vm.toString(contentCoinHookSalt));
        
        // IHooks contentCoinHook = HooksDeployment.deployContentCoinHook(
        //     address(POOL_MANAGER),
        //     address(ZORA_FACTORY_PROXY),
        //     trustedSenders,
        //     address(hookUpgradeGate),
        //     contentCoinHookSalt
        // );
        // console2.log("ContentCoinHook:", address(contentCoinHook));

        // (, bytes32 creatorCoinHookSalt) = HooksDeployment.mineForCreatorCoinSalt(
        //     address(this),
        //     address(POOL_MANAGER),
        //     address(ZORA_FACTORY_PROXY),
        //     trustedSenders,
        //     address(hookUpgradeGate)
        // );
        // console2.log("CreatorCoinHook salt:", vm.toString(creatorCoinHookSalt));

        // /// @dev Why is this not consistent fml
        // IHooks creatorCoinHook = HooksDeployment.deployHookWithSalt(
        //     HooksDeployment.creatorCoinHookCreationCode(
        //         address(POOL_MANAGER),
        //         address(ZORA_FACTORY_PROXY),
        //         trustedSenders,
        //         address(hookUpgradeGate)
        //     ),
        //     creatorCoinHookSalt
        // );
        // console2.log("CreatorCoinHook:", address(creatorCoinHook));

        HooksDeployer hooksDeployer = new HooksDeployer();

        // (address contentCoinHook, bytes32 contentCoinHookSalt) = hooksDeployer.deployContentCoinHook(
        //     address(POOL_MANAGER),
        //     address(ZORA_FACTORY_PROXY),
        //     trustedSenders,
        //     address(hookUpgradeGate)
        // );
        // console2.log("ContentCoinHook:", address(contentCoinHook));
        // console2.log("ContentCoinHook salt:", vm.toString(contentCoinHookSalt));

        address contentCoinHook;
        bytes32 contentCoinHookSalt;

        try hooksDeployer.deployContentCoinHook(
            address(POOL_MANAGER),
            address(ZORA_FACTORY_PROXY),
            trustedSenders,
            address(hookUpgradeGate)
        ) returns (address hook, bytes32 salt) {
            contentCoinHook = hook;
            contentCoinHookSalt = salt;
            console2.log("ContentCoinHook deployed!");
        } catch Error(string memory reason) {
            console2.log("ContentCoinHook failed:", reason);
            contentCoinHook = address(0);
        } catch (bytes memory) {
            console2.log(" ContentCoinHook failed: unknown error");
            contentCoinHook = address(0);
        }

        console2.log("ContentCoinHook:", address(contentCoinHook));
        console2.log("ContentCoinHook salt:", vm.toString(contentCoinHookSalt));

        // (address creatorCoinHook, bytes32 creatorCoinHookSalt) = hooksDeployer.deployCreatorCoinHook(
        //     address(POOL_MANAGER),
        //     address(ZORA_FACTORY_PROXY),
        //     trustedSenders,
        //     address(hookUpgradeGate)
        // );
        // console2.log("CreatorCoinHook:", address(creatorCoinHook));
        // console2.log("CreatorCoinHook salt:", vm.toString(creatorCoinHookSalt));

        address creatorCoinHook;
        bytes32 creatorCoinHookSalt;

        try hooksDeployer.deployCreatorCoinHook(
            address(POOL_MANAGER),
            address(ZORA_FACTORY_PROXY),
            trustedSenders,
            address(hookUpgradeGate)
        ) returns (address hook, bytes32 salt) {
            creatorCoinHook = hook;
            creatorCoinHookSalt = salt;
            console2.log("CreatorCoinHook deployed!");
        } catch Error(string memory reason) {
            console2.log("CreatorCoinHook failed:", reason);
            creatorCoinHook = address(0);
        } catch (bytes memory) {
            console2.log("CreatorCoinHook failed: unknown error");
            creatorCoinHook = address(0);
        }

        console2.log("CreatorCoinHook:", address(creatorCoinHook));
        console2.log("CreatorCoinHook salt:", vm.toString(creatorCoinHookSalt));

        vm.stopBroadcast();
        
        // 3. Deploy new ZoraFactoryImpl with all the required constructor args
        vm.startBroadcast();
        
        ZoraFactoryImpl newFactoryImpl = new ZoraFactoryImpl(
            address(coinImpl),          // coinImpl (V3)
            address(coinV4Impl),        // coinV4Impl 
            address(creatorCoinImpl),   // creatorCoinImpl
            address(contentCoinHook),   // contentCoinHook
            address(creatorCoinHook)    // creatorCoinHook
        );
        console2.log("New factory impl:", address(newFactoryImpl));
        
        vm.stopBroadcast();
        
        // 4. Upgrade the proxy (impersonate admin owner)
        vm.startPrank(adminOwner);
        UUPSUpgradeable(ZORA_FACTORY_PROXY).upgradeToAndCall(
            address(newFactoryImpl),
            ""
        );
        vm.stopPrank();
        
        console2.log("=== Factory upgraded successfully ===");
        
        // 5. Verify deployCreatorCoin exists now
        ZoraFactoryImpl factory = ZoraFactoryImpl(ZORA_FACTORY_PROXY);
        
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
        
        // 6. Deploy own contracts
        vm.startBroadcast();

        manager = new Manager();
        console2.log("Manager:", address(manager));
        
        walletFactory = new WalletFactory(address(manager));
        console2.log("WalletFactory:", address(walletFactory));
        
        // Set wallet factory on manager
        manager.updateWalletFactory(address(walletFactory));
        
        vm.stopBroadcast();
        
        // 7. Test onboard flow
        testOnboard();

        // 8. Test coin
        testCoin();
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

    function testCoin() internal {}
}

/// @notice This contract is an attempt to get around CREATE2 and Uniswap complexities
/// @dev Error :: `HooksDeployer` is above the contract size limit (94696 > 24576)
contract HooksDeployer is Script {

    event NewSaltCalculated(bytes32 salt, address deployer, string hookName);

    function deployContentCoinHook(
        address poolManager,
        address coinVersionLookup,
        address[] memory trustedSenders,
        address upgradeGate
    ) external returns (address hook, bytes32 salt) {
        // (hook, salt) = HooksDeployment.mineForContentCoinSalt(
        //     address(this), poolManager, coinVersionLookup, trustedSenders, upgradeGate
        // );

        // emit NewSaltCalculated(salt, address(this), "ContentCoinHook");
        
        // IHooks deployedHook = HooksDeployment.deployContentCoinHook(
        //     poolManager, coinVersionLookup, trustedSenders, upgradeGate, salt
        // );
        // return (address(deployedHook), salt);

        /// @dev `deployHookWithExistingOrNewSalt` does not use `vm`
        (IHooks hook_, bytes32 salt_) = HooksDeployment.deployHookWithExistingOrNewSalt(
            address(this),
            HooksDeployment.contentCoinCreationCode(
                poolManager, 
                coinVersionLookup, 
                trustedSenders, 
                upgradeGate
            ),
            salt
        );

        return (address(hook_), salt_);
    }
    
    function deployCreatorCoinHook(
        address poolManager,
        address coinVersionLookup,
        address[] memory trustedSenders,
        address upgradeGate
    ) external returns (address hook, bytes32 salt) {
        // (hook, salt) = HooksDeployment.mineForCreatorCoinSalt(
        //     address(this), poolManager, coinVersionLookup, trustedSenders, upgradeGate
        // );

        // emit NewSaltCalculated(salt, address(this), "CreatorCoinHook");
        
        // IHooks deployedHook = HooksDeployment.deployHookWithSalt(
        //     HooksDeployment.creatorCoinHookCreationCode(poolManager, coinVersionLookup, trustedSenders, upgradeGate),
        //     salt
        // );
        // return (address(deployedHook), salt);

        /// @dev `deployHookWithExistingOrNewSalt` does not use `vm`
        (IHooks hook_, bytes32 salt_) = HooksDeployment.deployHookWithExistingOrNewSalt(
            address(this),
            HooksDeployment.creatorCoinHookCreationCode(
                poolManager, 
                coinVersionLookup, 
                trustedSenders, 
                upgradeGate
            ),
            bytes32(0)
        );

        return (address(hook_), salt_);
    }
}