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
    mapping(address => bool) private _authorizedContracts;   //contracts that are allowed to call this


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
        _authorizedContracts[msg.sender] = true;
    }


    //--------------------------------------------------------------------------------
    // DoA Functions 
    //--------------------------------------------------------------------------------
    function nftMinted(address member, uint256 tokenId, NFT_CLASS nftClass) external override {
        //TODO require(_authorizedContracts[msg.sender], "Not authorized to call this function");

        if(nftClass == NFT_CLASS.HERO) {
            _heroNFTOwners[member] += 1;
        } else if(nftClass == NFT_CLASS.LEGEND) {
            _legendNFTOwners[member] += 1;
        } else if(nftClass == NFT_CLASS.RARE) {
            _rareNFTOwners[member] += 1;
        } else if(nftClass == NFT_CLASS.UNCOMMON) {
            _uncommonNFTOwners[member] += 1;
        } else if(nftClass == NFT_CLASS.COMMON) {
            _commonNFTOwners[member] += 1;
        }
    }

    function nftBurned(address member, uint256 tokenId, NFT_CLASS nftClass) external override {
        //TODO require(_authorizedContracts[msg.sender], "Not authorized to call this function");

        if(nftClass == NFT_CLASS.HERO) {
            _heroNFTOwners[member] -= 1;
        } else if(nftClass == NFT_CLASS.LEGEND) {
            _legendNFTOwners[member] -= 1;
        } else if(nftClass == NFT_CLASS.RARE) {
            _rareNFTOwners[member] -= 1;
        } else if(nftClass == NFT_CLASS.UNCOMMON) {
            _uncommonNFTOwners[member] -= 1;
        } else if(nftClass == NFT_CLASS.COMMON) {
            _commonNFTOwners[member] -= 1;
        }
    }

    function getMemberClass(address member) external view override returns (NFT_CLASS) {
        if(_heroNFTOwners[member] > 0) {
            return NFT_CLASS.HERO;
        } else if(_legendNFTOwners[member] > 0) {
            return NFT_CLASS.LEGEND;
        } else if(_rareNFTOwners[member] > 0) {
            return NFT_CLASS.RARE;
        } else if(_uncommonNFTOwners[member] > 0) {
            return NFT_CLASS.UNCOMMON;
        } else if(_commonNFTOwners[member] > 0) {
            return NFT_CLASS.COMMON;
        } else {
            revert("Not a member");
        }
    }

    function nftTransferred(address oldMember, address toNewMember, uint256 tokenID) external override {
    }


    //--------------------------------------------------------------------------------
    // Utility
    //--------------------------------------------------------------------------------



}