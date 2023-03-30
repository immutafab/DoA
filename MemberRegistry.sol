// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./iMemberRegistry.sol";
import "./DoAConstants.sol";
import "./DoACollection.sol";

contract MemberRegistry is iMemberRegistry {

    //--------------------------------------------------------------------------------
    // State
    //--------------------------------------------------------------------------------
    DoACollection private _doaCollection;

    mapping(address => uint16) private _heroNFTOwners;
    mapping(address => uint16) private _legendNFTOwners;
    mapping(address => uint16) private _rareNFTOwners;
    mapping(address => uint16) private _uncommonNFTOwners;
    mapping(address => uint16) private _commonNFTOwners;    

    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------

    constructor(address doaCollection) {
        _doaCollection = DoACollection(doaCollection);
    }


    //--------------------------------------------------------------------------------
    // DoA Functions 
    //--------------------------------------------------------------------------------
    function nftMinted(address member, uint256 tokenId, NFT_CLASS nftClass) external override {
        if(nftClass )
    }

    function nftBurned(address member, uint256 tokenId) external override {
    }

    function getMemberClass(address member) external view override returns (NFT_CLASS) {
        return _memberClass[member];
    }

    function nftTransferred(address oldMember, address toNewMember, uint256 tokenID) external override {
    }


    //--------------------------------------------------------------------------------
    // Utility
    //--------------------------------------------------------------------------------



}