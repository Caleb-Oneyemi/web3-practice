// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract MyFungibleToken is ERC20 {
    //token name && symbol
    constructor() ERC20('FungibleToken', 'FTKN') {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(uint _quantity) public {
        _mint(msg.sender, _quantity);
    }

    function burn(uint _quantity) public {
        _burn(msg.sender, _quantity);
    }
}
