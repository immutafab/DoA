// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface iHelloWorld {
    /// @dev Returns a string containing "Hello, world!".
    function sayHelloWorld() external  returns (string memory);
}