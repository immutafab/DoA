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
    function nftMinted(address member, uint256 tokenID) external override {
        _memberClass[member] = getMemberHighestClass(member);
    }

    function nftBurned(address member, uint256 tokenID) external override {
    }

    function getMemberClass(address member) external view override returns (NFT_CLASS) {
        return getMemberHighestClass(member);
    }

    function nftTransferred(address oldMember, address toNewMember, uint256 tokenID) external override {
    }


    //--------------------------------------------------------------------------------
    // Utility
    //--------------------------------------------------------------------------------

    //get tokenIDs of all tokens owned by member
    function getTokensOfOwner(address member) private view returns (uint256[] memory) {
        uint256 numTokens = erc721.balanceOf(owner);
        uint256[] memory tokenIDs = new uint256[](numTokens);

        for (uint256 i = 0; i < numTokens; i++) {
            tokenIDs[i] = _doaCollection.tokenOfOwnerByIndex(owner, i);
        }

        return tokenIDs;
    }


    function getMemberHighestClass(address member) private view returns (NFT_CLASS) {
        //get all the token ids owned by memer
        uint256[] memory memberTokenIDs = getTokensOfOwner(member);

        require(memberTokensIDs.length > 0, "no tokens");

        //get the class of each token
        NFT_CLASS[] memory memberTokenClasses = new NFT_CLASS[](memberTokenIDs.length);
        for (uint256 i = 0; i < memberTokenIDs.length; i++) {
            memberTokenClasses[i] = DoAConstants.getClass(memberTokenIDs[i]);
        }

        //get the highest class from the member's tokens
        NFT_CLASS highestClass = NFT_CLASS.COMMON;
        for (uint256 i = 0; i < memberTokenClasses.length; i++) {
            if (memberTokenClasses[i] < highestClass) {     //note: lower number is higher class
                highestClass = memberTokenClasses[i];
            }
        }

        return highestClass;
    }


}