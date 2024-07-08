// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract Counter {
    int private count;

    constructor() {
        count = 0;
    }

    function getCount() public view returns (int) {
        return count;
    }

    function increment() public {
        count++;
    }

    function decrement() public {
        count--;
    }
}
