
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import { IERC20 } from "openzeppelin/token/ERC20/IERC20.sol";
import { SafeERC20 } from "openzeppelin/token/ERC20/utils/SafeERC20.sol";

/**
 * @title TokenFaucet
 * @notice Allow users to claim tokens that were deposited in this contract.
 */
interface ITokenFaucet {
  function drip(IERC20 _token) external;
}