// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import { console2 } from "forge-std/console2.sol";

import { UserFaker } from "../src/UserFaker.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract UserFakerTest is Test {
  uint256 public mainnetFork;

  UserFaker public fooContract = new UserFaker();

  function setUp() public {
  }

  /// @dev Simple test. Run Forge with `-vvvv` to see console logs.
  function testBlah() external {
  }
}
