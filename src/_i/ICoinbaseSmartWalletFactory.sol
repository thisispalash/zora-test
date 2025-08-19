// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

interface ICoinbaseSmartWalletFactoryMinimal {
  function createAccount(bytes[] calldata owners, uint256 nonce) external returns (address);
  function getAddress(bytes[] calldata owners, uint256 nonce) external view returns (address);
}