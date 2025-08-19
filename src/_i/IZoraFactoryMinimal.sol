// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22 < 0.9.0;

import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";

interface IZoraFactoryMinimal {

  event CoinCreatedV4(
    address indexed caller,
    address indexed payoutRecipient,
    address indexed platformReferrer,
    address currency,
    string uri,
    string name,
    string symbol,
    address coin,
    PoolKey poolKey,
    bytes32 poolKeyHash,
    string version
  );

  event CreatorCoinCreated(
    address indexed caller,
    address indexed payoutRecipient,
    address indexed platformReferrer,
    address currency,
    string uri,
    string name,
    string symbol,
    address coin,
    PoolKey poolKey,
    bytes32 poolKeyHash,
    string version
  );

  /**
   * Predict the coin address before deployment
   * 
   * @param msgSender Address of user account
   * @param name Human-readable name of the coin
   * @param symbol Trading symbol for the coin
   * @param poolConfig Encoded configuration determining coin version and pool parameters
   * @param platformReferrer Address that receives platform referral rewards (use address(0) if none)
   * @param coinSalt Salt for deterministic deployment (enables predictable addresses)
   */
  function coinAddress(
    address msgSender,
    string memory name,
    string memory symbol,
    bytes memory poolConfig,
    address platformReferrer,
    bytes32 coinSalt
  ) external view returns (address);

  /**
   * Deploy a Content Coin (version 4) using Zora Protocol
   * 
   * @notice The msg.sender that calls the deployment function is considered the creator of the coin.
   * 
   * @param payoutRecipient Address that receives creator rewards from trading activity
   * @param owners Array of addresses with permission to manage the coin (update metadata and payout recipient)
   * @param uri Metadata URI for the coin (typically an IPFS URL)
   * @param name Human-readable name of the coin
   * @param symbol Trading symbol for the coin
   * @param poolConfig Encoded configuration determining coin version and pool parameters
   * @param platformReferrer Address that receives platform referral rewards (use address(0) if none)
   * @param postDeployHook Contract address to call after deployment (use address(0) if none)
   * @param postDeployHookData Data to pass to the post-deployment hook (use empty bytes if none)
   * @param coinSalt Salt for deterministic deployment (enables predictable addresses)
   * 
   * @return coin Address of the Content Coin
   * @return postDeployHookDataOut Data returned from the post-deployment hook
   */
  function deploy(
    address payoutRecipient,
    address[] memory owners,
    string memory uri,
    string memory name,
    string memory symbol,
    bytes memory poolConfig,
    address platformReferrer,
    address postDeployHook,
    bytes calldata postDeployHookData,
    bytes32 coinSalt
  ) external payable returns (address coin, bytes memory postDeployHookDataOut);

  /**
   * Deploy a Creator Coin using Zora Protocol
   * 
   * @notice The msg.sender that calls the deployment function is considered the creator. 
   * @notice Multiple calls allowed, but Zora indexer considers only first coin as official.
   * 
   * @param payoutRecipient Address that receives creator rewards from trading activity
   * @param owners Array of addresses with permission to manage the coin (update metadata and payout recipient)
   * @param uri Metadata URI for the coin (typically an IPFS URL)
   * @param name Human-readable name of the coin
   * @param symbol Trading symbol for the coin
   * @param poolConfig Encoded configuration determining coin version and pool parameters
   * @param platformReferrer Address that receives platform referral rewards (use address(0) if none)
   * @param coinSalt Salt for deterministic deployment (enables predictable addresses)
   *
   * @return creatorCoin Address of the Creator Coin
   */
  function deployCreatorCoin(
    address payoutRecipient,
    address[] memory owners,
    string memory uri,
    string memory name,
    string memory symbol,
    bytes memory poolConfig,
    address platformReferrer,
    bytes32 coinSalt
  ) external returns (address creatorCoin);

}