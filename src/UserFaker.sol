// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import { Create2 } from "openzeppelin/contracts-upgradeable/utils/Create2.sol";
import { FakeUser, Call } from "./FakeUser.sol";
import { MinimalProxyLibrary } from "./libraries/MinimalProxyLibrary.sol";

contract UserFaker {

  FakeUser fakeUserInstance;
  bytes internal fakeUserBytecode;

  mapping(address => uint256) vaultFakeUserCount;

  int lastCreatedFakeUser = -1;

  /// @notice Constructs a new controller.
  /// @dev Creates a new FakeUser instance and an associated minimal proxy.
  constructor () public {
    fakeUserInstance = new FakeUser();
    fakeUserInstance.initialize();
    fakeUserBytecode = MinimalProxyLibrary.minimalProxy(address(fakeUserInstance));
  }

  function setFakeUsers(address vault, uint256 count) public {
    uint currentCount = vaultFakeUserCount[vault];
    if (count < currentCount) {
      for (uint i = count; i < currentCount; i++) {
        _withdrawUser(vault, i);
      }
    } else {
      for (uint i = currentCount; i < count; i++) {
        _depositUser(vault, i);
      }
    }
  }

  function _withdrawUser(address _vault, uint256 _userIndex) internal {
    FakeUser fakeUser = FakeUser(computeAddress(_vault, _userIndex));
    Call[] memory calls = new Call[](1);
    calls[0] = Call({
      to: _vault,
      data:     
    })
    fakeUser.executeCalls(calls);
  }

  function _depositUser(address _vault, uint256 _userIndex) internal {
    FakeUser fakeUser;
    if (lastCreatedFakeUser < userIndex) {
      fakeUser = _createFakeUser(_vault, _userIndex);
    } else {
      fakeUser = FakeUser(computeAddress(_vault, _userIndex));
    }

  }

  /// @notice Computes the Loot Box address for a given Vault token.
  /// @dev The contract will not exist yet, so the Loot Box address will have no code.
  /// @param _vault The vault
  /// @param _userIndex The user index
  /// @return The address of the Loot Box.
  function computeAddress(address _vault, uint256 _userIndex) public view returns (address) {
    return Create2.computeAddress(_salt(_vault, _userIndex), keccak256(fakeUserBytecode));
  }

  /// @notice Creates a Loot Box for the given Vault token.
  /// @param _vault The Vault address
  /// @param _userIndex The user index
  /// @return The address of the newly created FakeUser.
  function _createFakeUser(address _vault, uint256 _userIndex) internal returns (FakeUser) {
    FakeUser fakeUser = FakeUser(Create2.deploy(0, _salt(_vault, _userIndex), fakeUserBytecode));
    fakeUser.initialize();
    return fakeUser;
  }

  /// @notice Computes the CREATE2 salt for the given Vault token.
  /// @param _vault The Vault address
  /// @param _userIndex The user index
  /// @return A bytes32 value that is unique to that Vault token.
  function _salt(address vault, uint256 _userIndex) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(vault, _userIndex));
  }

}
