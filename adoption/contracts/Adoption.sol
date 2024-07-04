// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;
contract Adoption {
    address[10] public adopters;

    function adopt(uint8 petId) public returns (uint8) {
        require(petId >= 1 && petId <= 10, "pet id must be in range 1 to 10");

        adopters[petId - 1] = msg.sender;

        return petId - 1;
    }

    function getAdopters() public view returns (address[10] memory) {
        return adopters;
    }
}
