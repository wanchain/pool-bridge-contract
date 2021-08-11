// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "./Layer2BridgeStorage.sol";

contract Layer2BridgeDelegate is
    Initializable,
    AccessControl,
    Layer2BridgeStorage
{
    event Stake(address indexed user, uint256 amount);

    event Withdraw(address indexed user, uint256 amount);

    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "no access");
        _;
    }

    function initialize(address _admin, address _tokenAddress)
        external
        initializer
    {
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        erc20Token = ERC20(_tokenAddress);
    }

    function initializeV2() external initializer {
        tokenSet.add(address(erc20Token));
        tokens[address(erc20Token)].tokenAddr = address(erc20Token);
        tokens[address(erc20Token)].symbol = erc20Token.symbol();
        tokens[address(erc20Token)].decimal = erc20Token.decimals();
        tokens[address(erc20Token)].enabled = true;
    }

    function name() external view returns (string memory) {
        return erc20Token.name();
    }

    function symbol() external view returns (string memory) {
        return erc20Token.symbol();
    }

    function decimals() external view returns (uint8) {
        return erc20Token.decimals();
    }

    function totalSupply() external view returns (uint256) {
        return erc20Token.totalSupply();
    }

    function balanceOf(address account) external view returns (uint256) {
        return erc20Token.balanceOf(account);
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return erc20Token.allowance(owner, spender);
    }

    function mint(address account, uint256 value)
        public
        onlyAdmin
        returns (bool)
    {
        erc20Token.safeTransfer(account, value);
        totalMint = totalMint.add(value);
        return true;
    }

    function burn(address account, uint256 value)
        public
        onlyAdmin
        returns (bool)
    {
        erc20Token.safeTransferFrom(account, address(this), value);
        totalBurn = totalBurn.add(value);
        return true;
    }

    function getStakerCountByToken(address tokenAddr)
        external
        view
        returns (uint256 count)
    {
        return stakerSet[tokenAddr].length();
    }

    function getStakeAddrByIndex(address tokenAddr, uint256 index)
        external
        view
        returns (address from)
    {
        return stakerSet[tokenAddr].at(index);
    }

    function getTokenCount() external view returns (uint256 count) {
        return tokenSet.length();
    }

    function getTokenAddressByIndex(uint256 index)
        external
        view
        returns (address token)
    {
        return tokenSet.at(index);
    }

    function stake(uint256 amount) external {
        address tokenAddr = address(erc20Token);

        erc20Token.safeTransferFrom(msg.sender, address(this), amount);

        Staker storage s = stakers[tokenAddr][msg.sender];
        if (!stakerSet[tokenAddr].contains(msg.sender)) {
            stakerSet[tokenAddr].add(msg.sender);
        }
        s.amount = s.amount.add(amount);
        emit Stake(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        address user = msg.sender;
        address tokenAddr = address(erc20Token);
        require(stakerSet[tokenAddr].contains(user), "unknown staker");
        Staker storage s = stakers[tokenAddr][user];
        uint256 amount = s.amount;
        s.amount = 0;

        stakerSet[tokenAddr].remove(user);
        delete stakers[tokenAddr][user];

        erc20Token.safeTransfer(user, amount);
        emit Withdraw(user, amount);
    }
}
