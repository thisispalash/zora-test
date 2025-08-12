// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24 < 0.9.0;

interface IZoraAccountManager {
    function createSmartWallet(bytes[] calldata encodedOwners, uint256 nonce) external returns (address);
}