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
    mapping(address => NFT_CLASS) private _memberClass;

    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------

    constructor(address doaCollection) {
        _doaCollection = DoACollection(doaCollection);
    }


    //--------------------------------------------------------------------------------
    // DoA Functions 
    //--------------------------------------------------------------------------------
    function nftMinted(address member, uint256 tokenId) external override {
        NFT_CLASS newClass = DoAConstants.getClassForTokenId(tokenId);

        NFT_CLASS oldClass = _memberClass[member];

        if(newClass < oldClass) {
            _memberClass[member] = newClass;
        }
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