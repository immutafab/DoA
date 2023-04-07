// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DoAConstants.sol";

interface iMemberRegistry {

    function nftMinted(address member, NFT_CLASS nftClasse) external;
    function nftBurned(address member, NFT_CLASS nftClasse) external;
    function getMemberClass(address member) external returns (NFT_CLASS);

    function nftTransferred(address oldMember, address toNewMember, uint256 tokenId) external;


}