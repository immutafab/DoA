// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


interface iTokenMinter {

    //mints the hero tokens
    function mintHeros(address to) external; 
}