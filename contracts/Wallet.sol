// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23 < 0.9.0;

import {ICoinbaseSmartWalletFactory} from "github/ourzora/zora-protocol/packages/smart-wallet/src/interfaces/ICoinbaseSmartWalletFactory.sol";

contract Wallet {

    ICoinbaseSmartWalletFactory public constant smartWalletFactory = ICoinbaseSmartWalletFactory(0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a);
    address public MANAGER = 0x96e03e38aD4B5EF728f4C5F305eddBB509B652d0;

    function deploy() external returns (address) {

        bytes memory managerEncoded = abi.encodePacked(MANAGER);
        bytes memory senderEncoded = abi.encodePacked(msg.sender);

        bytes[] memory owners;
        owners[0] = senderEncoded;
        owners[1] = managerEncoded;

        smartWalletFactory.createAccount(owners, 1);

        return smartWalletFactory.getAddress(owners, 1);

    }
}