// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;



interface iTreasury {


    function depositNFTRevenue() external payable;

    function withdrawPrivateFund(uint256 amount) external ;
    
    function getCombinedBalance() external view returns (uint256) ;
}