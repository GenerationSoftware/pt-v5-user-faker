// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import { ERC4626 } from "openzeppelin/token/ERC20/extensions/ERC4626.sol";
import { Create2 } from "openzeppelin/utils/Create2.sol";
import { FakeUser, Call } from "./FakeUser.sol";
import { MinimalProxyLibrary } from "./libraries/MinimalProxyLibrary.sol";
import { Vault } from "v5-vault/Vault.sol";
import { Address } from "openzeppelin/utils/Address.sol";

contract UserFaker {
  using Address for address;

  FakeUser fakeUserInstance;
  bytes internal fakeUserBytecode;

  mapping(Vault => uint256) vaultFakeUserCount;
  
  /// @notice Constructs a new controller.
  /// @dev Creates a new FakeUser instance and an associated minimal proxy.
  constructor () public {
    fakeUserInstance = new FakeUser();
    fakeUserInstance.initialize();
    fakeUserBytecode = MinimalProxyLibrary.minimalProxy(address(fakeUserInstance));
  }

  function setFakeUsers(Vault _vault, uint256 count) public {
    uint currentCount = vaultFakeUserCount[_vault];
    if (count < currentCount) {
      for (uint i = count; i < currentCount; i++) {
        _withdrawUser(_vault, i);
      }
    } else {
      for (uint i = currentCount; i < count; i++) {
        _depositUser(_vault, i);
      }
    }
  }

  function _withdrawUser(Vault _vault, uint256 _userIndex) internal {
    FakeUser fakeUser = FakeUser(computeAddress(_vault, _userIndex));
    uint256 balance = _vault.balanceOf(address(fakeUser));
    Call[] memory calls = new Call[](1);
    calls[0] = Call({
      to: address(_vault),
      value: 0,
      data: abi.encodeWithSelector(ERC4626.redeem.selector, balance, address(fakeUser), address(fakeUser))
    });
    fakeUser.executeCalls(calls);
  }

  function _depositUser(Vault _vault, uint256 _userIndex) internal {
    FakeUser fakeUser = FakeUser(computeAddress(_vault, _userIndex));
    if (!address(fakeUser).isContract()) {
      fakeUser = _createFakeUser(_vault, _userIndex);
    }
    Call[] memory calls = new Call[](1);
    // calls[0] = Call({
    //   to: _vault,
    //   value: 0,
    //   data: abi.encodeWithSelector(Vault.redeem.selector, balance, address(fakeUser), address(fakeUser)),
    // });
    fakeUser.executeCalls(calls);
  }

  /// @notice Computes the Loot Box address for a given Vault token.
  /// @dev The contract will not exist yet, so the Loot Box address will have no code.
  /// @param _vault The vault
  /// @param _userIndex The user index
  /// @return The address of the Loot Box.
  function computeAddress(Vault _vault, uint256 _userIndex) public view returns (address) {
    return Create2.computeAddress(_salt(_vault, _userIndex), keccak256(fakeUserBytecode));
  }

  /// @notice Creates a Loot Box for the given Vault token.
  /// @param _vault The Vault address
  /// @param _userIndex The user index
  /// @return The address of the newly created FakeUser.
  function _createFakeUser(Vault _vault, uint256 _userIndex) internal returns (FakeUser) {
    FakeUser fakeUser = FakeUser(Create2.deploy(0, _salt(_vault, _userIndex), fakeUserBytecode));
    fakeUser.initialize();
    return fakeUser;
  }

  /// @notice Computes the CREATE2 salt for the given Vault token.
  /// @param _vault The Vault address
  /// @param _userIndex The user index
  /// @return A bytes32 value that is unique to that Vault token.
  function _salt(Vault _vault, uint256 _userIndex) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(_vault, _userIndex));
  }

}
