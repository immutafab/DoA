// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


interface iTokenMinter {


    function addAuthorizedContract(address contractAddress) external;

    //mints the hero tokens
    function mintHeros(address to) external; 
}