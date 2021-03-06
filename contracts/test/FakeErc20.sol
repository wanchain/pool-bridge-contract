// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FakeErc20 is ERC20, Ownable {
  constructor(string memory name_, string memory symbol_) public ERC20(name_, symbol_) {}
  function mint(address to_, uint amount_) external onlyOwner {
    _mint(to_, amount_);
  }
}
