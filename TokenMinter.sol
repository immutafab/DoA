// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./iTokenMinter.sol";
import "./DoAConstants.sol";
import "./iDoACollection.sol";


contract TokenMinter is iTokenMinter, Ownable, Pausable, ReentrancyGuard {
    using Counters for Counters.Counter;



    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------
    iDoACollection private _doaCollection;

    mapping(address => bool) private _authorizedContracts;   //contracts that are allowed to call this

    //map collectionID to NFT type
    mapping(uint256 => NFT_TYPE) private _collectionIDToNFTType;

    //# sold NFTs
    Counters.Counter private _heroNFTCounter;
    Counters.Counter private _legendNFTCounter;
    Counters.Counter private _rareNFTCounter;
    Counters.Counter private _uncommonNFTCounter;
    Counters.Counter private _commonNFTCounter;


    //# round control
    bool private _areHerosMinted;
    bool private _is1stPublicRoundUnlocked;
    bool private _is2ndPublicRoundUnlocked;
    bool private _is3rdPublicRoundUnlocked;



    //--------------------------------------------------------------------------------
    // Utility functions
    //--------------------------------------------------------------------------------
    

    //--------------------------------------------------------------------------------
    // Modifiers
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    // Events
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------

    constructor(address doaCollectionAddress) {
        _doaCollection = iDoACollection(doaCollectionAddress);
        _authorizedContracts[msg.sender] = true; //add owner as authorized contract
    }


    function addAuthorizedContract(address contractAddress) public onlyOwner {
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



    //--------------------------------------------------------------------------------
    // Functions: DoA Internal
    //--------------------------------------------------------------------------------
    
    function mintHeros(address toAddr) external override whenNotPaused nonReentrant {
        require(_authorizedContracts[msg.sender], "No Auth");
        require(toAddr != address(0), "Invalid address");
        require(!_areHerosMinted, "Already minted");


        //generate token IDs
        uint256[] memory tokenIds = new uint256[](DoAConstants.HERO_NFT_SUPPLY_1st);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            tokenIds[i] = i + 1;
        }


        _doaCollection.safeBatchMint(toAddr, tokenIds);

        _areHerosMinted = true;

    }


}