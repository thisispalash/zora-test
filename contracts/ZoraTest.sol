// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23 < 0.9.0;

import {ZoraAccountManagerImpl} from "github/ourzora/zora-protocol/packages/smart-wallet/src/ZoraAccountManagerImpl.sol";
import {ZoraFactoryImpl} from "@zoralabs/coins/src/ZoraFactoryImpl.sol";

contract ZoraTest {

    ZoraAccountManagerImpl public constant zoraAccountFactory = ZoraAccountManagerImpl(0x0Ba958A449701907302e28F5955fa9d16dDC45c3);
    ZoraFactoryImpl public constant zoraFactory = ZoraFactoryImpl(0x777777751622c0d3258f214f9df38e35bf45baf3);


    address public MANAGER = 0x96e03e38aD4B5EF728f4C5F305eddBB509B652d0;

    /// @dev `_wallet` is the address of the custom smart wallet
    function createZoraAccount(address _wallet) external returns (address) {

        bytes memory managerEncoded = abi.encode(MANAGER);
        bytes memory walletEncoded = abi.encode(_wallet);
        bytes memory senderEncoded = abi.encode(msg.sender);

        bytes[] memory owners = new bytes[](3);
        owners[0] = senderEncoded; // user's EOA
        owners[1] = walletEncoded; // custom smart wallet
        owners[2] = managerEncoded; // dApp manager EOA / contract

        address _zoraAccount = zoraAccountFactory.createSmartWallet(owners, 1);

        return _zoraAccount;
    }

    function createCreatorCoin(address _zoraAccount) public {

        // deployCreatorCoin

    }

    function createCoin() public {

    }
    
}