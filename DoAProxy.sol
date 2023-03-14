// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;



import "@openzeppelin/contracts/access/Ownable.sol";

import "./iDoAProxy.sol"; 
import "./DoACollection.sol";
import "./TokenMinter.sol";
import "./iTokenMinter.sol";


contract DoAProxy is iDoAProxy, Ownable {
    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------
    iDoACollection private _doaCollection;
    iTokenMinter private _tokenMinter;

    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------
    
    constructor (address doaCollection, address tokenMinter) {
        _doaCollection = iDoACollection(doaCollection);
        _tokenMinter = iTokenMinter(tokenMinter);
    }



    //------------------------------------------------------------------------------------
    // Functions: IERC721
    //------------------------------------------------------------------------------------
    function name() external view returns (string memory) {
        return _doaCollection.name();
    }

    // Returns the symbol of the token.
    function symbol() external view returns (string memory) {
        return _doaCollection.symbol();
    }

    // Returns the number of NFTs in existence.
    function totalSupply() external view returns (uint256) {
        return _doaCollection.totalSupply();
    }

    // Returns the owner of a particular NFT.
    function ownerOf(uint256 _tokenId) external view returns (address) {}

    // Transfers ownership of an NFT from one address to another address.
    function transferFrom(address _from, address _to, uint256 _tokenId) external {}

    // Gives permission to another address to transfer the given NFT.
    function approve(address _approved, uint256 _tokenId) external {}

    // Returns the approved address for a single NFT.
    function getApproved(uint256 _tokenId) external view returns (address) {}

    // Enables or disables approval for a third party ("operator") to manage all of the caller's assets.
    function setApprovalForAll(address _operator, bool _approved) external {}

    // Returns true if an operator is approved to manage all of the assets of a particular owner.
    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {}

    // Safely transfers ownership of an NFT from one address to another address.
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external {}

    // Safely transfers ownership of an NFT from one address to another address, checking first that the recipient can receive it.
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {}

    //the number of tokens owned by the address
    function balanceOf(address owner) external view returns (uint256 balance) {}

    //------------------------------------------------------------------------------------
    // Functions: IERC721 Enumerable
    //------------------------------------------------------------------------------------

    // Returns the token identifier for the nth NFT.
    function tokenByIndex(uint256 _index) external view returns (uint256) {}

    // Returns the nth NFT assigned to an owner.
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {}


    //------------------------------------------------------------------------------------
    // Functions: IERC721 Metadata
    //------------------------------------------------------------------------------------

     // Returns the token collection symbol
    function tokenURI(uint256 tokenId) external view returns (string memory) {} // Returns the Uniform Resource Identifier (URI) for `tokenId` token.


    //------------------------------------------------------------------------------------
    // Functions: IERC721 Burnable
    //------------------------------------------------------------------------------------
    
    // Burns a specific NFT.
    function burn(uint256 tokenId) external {}
    // Burns a set of NFTs.
    function batchBurn(uint256[] calldata tokenIds) external {}

    
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {}

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {}


    //------------------------------------------------------------------------------------
    // Functions: DoA Functions
    //------------------------------------------------------------------------------------
    function safeMint(address to, string memory uri) external {
        _doaCollection.safeMint(to, uri);
    }


    function mintHeros(address to) external {
        _tokenMinter.mintHeros(to);
    }
}