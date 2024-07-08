// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

contract MyFungibleToken is ERC20, Ownable {
    //token name && symbol
    constructor(
        address initialOwner
    ) ERC20('FungibleToken', 'FTKN') Ownable(initialOwner) {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(uint _quantity) public onlyOwner {
        _mint(msg.sender, _quantity);
    }

    function burn(uint _quantity) public onlyOwner {
        _burn(msg.sender, _quantity);
    }
}
