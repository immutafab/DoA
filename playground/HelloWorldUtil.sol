// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;




library HelloWorldUtil  {

    function sayHelloWorld() external pure returns (string memory) {
        //revert("Error Hello World");
        return "Hello World";
    }
}