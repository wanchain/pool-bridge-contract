// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";

contract Layer2BridgeStorage {
    using SafeERC20 for ERC20;
    ERC20 public erc20Token;

    using SafeMath for uint256;
    uint256 public totalMint;
    uint256 public totalBurn;

    struct Staker {
        uint256 amount;
        bool quited;
        bytes32 quitGroupId; // quited groupID.
    }

    struct Token {
        address tokenAddr;
        string symbol;
        uint256 decimal;
        bool enabled;
    }

    EnumerableSet.AddressSet tokenSet;

    // tokenAddr=>tokenInfo
    mapping(address => Token) public tokens; 

    // tokenAddr => user addressSet
    mapping(address => EnumerableSet.AddressSet) stakerSet; 

    // tokenAddr => user => stakerInfo
    mapping(address => mapping(address => Staker)) public stakers; 

    uint public totalStaked;
}
