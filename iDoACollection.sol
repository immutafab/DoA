// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";


interface iDoACollection is IERC721, IERC721Enumerable, IERC721Metadata {

    
    //------------------------------------------------------------------------------------
    // DoA Specific
    //------------------------------------------------------------------------------------

    function safeMint(address to) external;

    function safeMint(address to, uint256 tokenID) external;

    function safeBatchMint(address to, uint256 tokensToMint) external;

    //------------------------------------------------------------------------------------
    // IERC721
    //------------------------------------------------------------------------------------
    
    // Event that is emitted when ownership of any NFT changes by any mechanism.
    //event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    // Event that is emitted when an approved address for an NFT is changed or reaffirmed.
    //event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    // Event that is emitted when an operator is enabled or disabled for an owner.
    //event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    // Returns the name of the token.
    function name() external view returns (string memory);

    // Returns the symbol of the token.
    function symbol() external view returns (string memory);

    // Returns the number of NFTs in existence.
    function totalSupply() external view returns (uint256);

    // Returns the owner of a particular NFT.
    function ownerOf(uint256 _tokenId) external view returns (address);

    // Transfers ownership of an NFT from one address to another address.
    function transferFrom(address _from, address _to, uint256 _tokenId) external;

    // Gives permission to another address to transfer the given NFT.
    function approve(address _approved, uint256 _tokenId) external;

    // Returns the approved address for a single NFT.
    function getApproved(uint256 _tokenId) external view returns (address);

    // Enables or disables approval for a third party ("operator") to manage all of the caller's assets.
    function setApprovalForAll(address _operator, bool _approved) external;

    // Returns true if an operator is approved to manage all of the assets of a particular owner.
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

    // Safely transfers ownership of an NFT from one address to another address.
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;

    // Safely transfers ownership of an NFT from one address to another address, checking first that the recipient can receive it.
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;

    //the number of tokens owned by the address
    function balanceOf(address owner) external view returns (uint256 balance);



    //------------------------------------------------------------------------------------
    // IERC721 Enumerable
    //------------------------------------------------------------------------------------

    // Returns the token identifier for the nth NFT.
    function tokenByIndex(uint256 _index) external view returns (uint256);

    // Returns the nth NFT assigned to an owner.
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);


    //------------------------------------------------------------------------------------
    // IERC721 Metadata
    //------------------------------------------------------------------------------------

     // Returns the token collection symbol
    function tokenURI(uint256 tokenId) external view returns (string memory); // Returns the Uniform Resource Identifier (URI) for `tokenId` token.


    //------------------------------------------------------------------------------------
    // IERC721 Burnable
    //------------------------------------------------------------------------------------
    
    // Burns a specific NFT.
    function burn(uint256 tokenId) external;
    // Burns a set of NFTs.
    function batchBurn(uint256[] calldata tokenIds) external;

    
}