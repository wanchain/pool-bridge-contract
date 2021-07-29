// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Layer2BridgeStorage {
    using SafeERC20 for ERC20;
    ERC20 public erc20Token;
}

