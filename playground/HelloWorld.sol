// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


//import "./iHelloWorld.sol";
import "./HelloWorldUtil.sol";


contract HelloWorld { //is iHelloWorld {

    function sayHelloWorld() external pure returns (string memory) {
        //return "hhhh";
        return HelloWorldUtil.sayHelloWorld();
    }
}