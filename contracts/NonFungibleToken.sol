// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract MyNonFungibleToken is ERC721 {
    //token name && symbol
    constructor() ERC721('NonFungibleToken', 'NFTK') {}

    function safeMint(address to, uint tokenId) public {
        _safeMint(to, tokenId);
    }
}
