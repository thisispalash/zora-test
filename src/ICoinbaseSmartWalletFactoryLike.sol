// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface ICoinbaseSmartWalletFactoryLike {
    function createAccount(bytes[] calldata owners, uint256 nonce) external returns (address);

    function getAddress(bytes[] calldata owners, uint256 nonce) external view returns (address);
}
