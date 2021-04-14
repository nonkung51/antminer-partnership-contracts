// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Partnership {
    
    IERC20 shareToken;
    IERC20 btcbToken;

    constructor(address _shareToken, address _btcbToken) {
        shareToken = IERC20(_shareToken);
        btcbToken = IERC20(_btcbToken);
    }
    
    function withdraw() public {
        require(shareToken.balanceOf(msg.sender) > 0, "You have no share in this pool!");
        btcbToken.transfer(msg.sender, _getWithdrawable(msg.sender));
    }
    
    function _getWithdrawable(address _address) private view returns (uint256) {
        return getPoolSupply() * shareToken.balanceOf(_address) / shareToken.totalSupply();
    }
    
    function getWithdrawable() public view returns (uint256) {
        return _getWithdrawable(msg.sender);
    }
    
    function getPoolSupply() public view returns (uint256) {
        return btcbToken.balanceOf(address(this));
    }
    
    function emergencyWithdraw() public {
        require(shareToken.balanceOf(msg.sender) > shareToken.totalSupply() / 2, "You need at least half of share to emergency withdraw!");
        btcbToken.transfer(msg.sender, getPoolSupply());
    }
}
