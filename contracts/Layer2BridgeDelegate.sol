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
        return true;
    }

    function burn(address account, uint256 value)
        public
        onlyAdmin
        returns (bool)
    {
        erc20Token.safeTransferFrom(account, address(this), value);
        return true;
    }
}
