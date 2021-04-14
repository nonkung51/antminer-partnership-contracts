// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ShareToken is ERC20 {

    constructor() ERC20("Antminer Share Token", "AST") {
        _mint(msg.sender, 100 * 1e18);
    }
}
