// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * Some of the code copied from openzeppelin's PaymentSplitter
 * modify to using ERC20 Token as share and using ERC20 other than ether
 * check the openzeppelin's contract here: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/PaymentSplitter.sol
**/

contract Partnership {
    
    IERC20 shareToken;
    IERC20 btcbToken;
    
    uint256 private _totalReleased;
    mapping(address => uint256) private _released;

    constructor(address _shareToken, address _btcbToken) {
        shareToken = IERC20(_shareToken);
        btcbToken = IERC20(_btcbToken);
    }
    
    function withdraw() public {
        require(shareToken.balanceOf(msg.sender) > 0, "You have no share in this pool!");
        uint256 totalReceived = btcbToken.balanceOf(address(this)) + _totalReleased;
        uint256 payment = totalReceived * shareToken.balanceOf(msg.sender) / shareToken.totalSupply() - _released[msg.sender];

        require(payment != 0, "You already claimed!");
        _released[msg.sender] = _released[msg.sender] + payment;
        _totalReleased = _totalReleased + payment;
        
        btcbToken.transfer(msg.sender, payment);
    }

    
    function getPoolSupply() public view returns (uint256) {
        return btcbToken.balanceOf(address(this));
    }
    
    function emergencyWithdraw() public {
        require(shareToken.balanceOf(msg.sender) > shareToken.totalSupply() / 2, "You need at least half of share to emergency withdraw!");
        btcbToken.transfer(msg.sender, getPoolSupply());
    }
}
