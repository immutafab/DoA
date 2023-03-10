// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;




contract HelloWorld is iHelloWorld {

    function sayHelloWorld() external pure returns (string memory) {
        //revert("Error Hello World");
        return "Hello World";
    }
}