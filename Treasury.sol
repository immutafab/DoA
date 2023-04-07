// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./iTreasury.sol";
import "./DoAConstants.sol";

contract Treasury is iTreasury, Ownable, Pausable, ReentrancyGuard {

    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------

    uint256 public privateFund;
    uint256 public publicFund;
    
    mapping(address => bool) private _authorizedContracts;   //contracts that are allo


    //--------------------------------------------------------------------------------
    // Utility functions
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------
    function addAuthorizedContract(address contractAddress) external  onlyOwner {
        _authorizedContracts[contractAddress] = true;
    }


    //--------------------------------------------------------------------------------
    // Functions: Owner
    //--------------------------------------------------------------------------------
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }




    //------------------------------------------------------------------------------------
    // Functions: DOA
    //------------------------------------------------------------------------------------

    function depositNFTRevenue() external  payable {
        //TODO:require(_authorizedContracts[msg.sender], "Not authorized");

        uint256 publicShare = (msg.value * uint256(DoAConstants.PUBLIC_FUND_PERCENTAGE)) / 100;
        
        publicFund += publicShare;
        privateFund += (msg.value - publicShare);
    }

    function withdrawPrivateFund(uint256 amount) external override onlyOwner {
        //TODO:require(_authorizedContracts[msg.sender], "Not authorized");

        require(amount <= privateFund, "Not enough funds");

        privateFund -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getCombinedBalance() public view returns (uint256) {
        return address(this).balance;
    }



}