// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DoAConstants.sol";

interface iMemberRegistry {

    function nftMinted(address member, uint256 tokenID, NFT_CLASS nftClass) external;
    function nftBurned(address member, uint256 tokenID, NFT_CLASS nftClass) external;
    function getMemberClass(address member) external returns (NFT_CLASS);

    function nftTransferred(address oldMember, address toNewMember, uint256 tokenID) external;


}