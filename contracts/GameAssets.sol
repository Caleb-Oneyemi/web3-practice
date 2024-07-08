// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract MyGameAssets is ERC1155, Ownable {
    //types of tokens in the Game
    uint8 public constant GOLD = 0;
    uint8 public constant SILVER = 1;
    uint8 public constant BRONZE = 2;

    constructor(
        address initialOwner
    ) ERC1155('https://website.com/assets/{id}.json') Ownable(initialOwner) {}

    function mint(
        address account,
        uint8 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function burn(address account, uint8 id, uint256 amount) public onlyOwner {
        _burn(account, id, amount);
    }
}
