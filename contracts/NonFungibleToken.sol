// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

contract MyNonFungibleToken is ERC721, Ownable {
    uint public tokenCounter;
    struct NFT {
        string name;
        string metadata;
    }

    mapping(uint => NFT) public myNFTs;

    constructor(
        address initialOwner
    ) ERC721('NonFungibleToken', 'NFTK') Ownable(initialOwner) {}

    function mintNFT(
        string memory _name,
        string memory _metadata
    ) public returns (uint) {
        uint tokenId = tokenCounter;
        myNFTs[tokenId] = NFT({name: _name, metadata: _metadata});

        _safeMint(msg.sender, tokenId);

        tokenCounter++;
        return tokenId;
    }

    function transferNFT(address to, uint tokenId) public onlyOwner {
        _safeTransfer(msg.sender, to, tokenId);
    }

    function burnNFT(uint tokenId) public onlyOwner {
        _burn(tokenId);
        delete myNFTs[tokenId];
    }
}
