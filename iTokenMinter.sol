// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./iTreasury.sol";

interface iTokenMinter {

    
    //mints the hero tokens
    function mintHeros(address to) external; 

    function mintLegends(address to, uint256 numToMint) external payable;
    function mintLegend(address to) external payable;

    function mintRares(address to, uint256 numToMint) external payable;
    function mintRare(address to) external payable;

    function mintUncommons(address to, uint256 numToMint) external payable;
    function mintUncommon(address to) external payable;


    function mintCommons(address to, uint256 numToMint) external payable;
    function mintCommon(address to) external payable;

    
}