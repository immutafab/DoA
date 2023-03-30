// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./iMemberRegistry.sol";
import "./DoAConstants.sol";

contract MemberRegistry is iMemberRegistry {

    mapping(address => NFT_CLASS) private _memberClass;



    function nftMinted(address member, uint256 tokenID, NFT_CLASS nftClass) external override {
        
    }

    function nftBurned(address member, uint256 tokenID, NFT_CLASS nftClass) external override {
    }

    function getMemberClass(address member) external override returns (NFT_CLASS) {
    }

    function nftTransferred(address oldMember, address toNewMember, uint256 tokenID) external override {
    }



}