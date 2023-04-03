// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;



import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./iDoACollection.sol"; 
import "./DoAConstants.sol";


contract DoACollection is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Pausable, Ownable {
    using Strings for uint256;
    

    //--------------------------------------------------------------------------------
    //  State Variables
    //-------------------------------------------------------------------------------- 
    mapping(address => bool) private _authorizedContracts;


    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------
    constructor() ERC721("Daughters of Arya", "DoA"){
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

    
   

    //------------------------------------------------------------------------------------
    // Functions: Required overrides
    //------------------------------------------------------------------------------------

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }


    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


    //------------------------------------------------------------------------------------
    // Functions: DoA specific
    //------------------------------------------------------------------------------------

    function _baseURI() internal pure override returns (string memory) { // Function to return the base URI for token metadata
        return DoAConstants.BASE_URI;
    }

    
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory uri) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        string memory baseClassURI;

        NFT_CLASS tokenClass = DoAConstants.getClassForTokenId(tokenId);

        if (tokenClass == NFT_CLASS.HERO) {
            baseClassURI = DoAConstants.BASE_HERO_URI;
        } else if (tokenClass == NFT_CLASS.LEGEND) {
            baseClassURI = DoAConstants.BASE_LEGEND_URI;
        } else if (tokenClass == NFT_CLASS.RARE) {
            baseClassURI = DoAConstants.BASE_RARE_URI;
        } else if(tokenClass == NFT_CLASS.UNCOMMON) {
            baseClassURI = DoAConstants.BASE_UNCOMMON_URI;
        } else if (tokenClass == NFT_CLASS.COMMON) {
            baseClassURI = DoAConstants.BASE_COMMON_URI;
        } else {
            revert("Invalid Class");
        }

        uri = string(abi.encodePacked(
            baseURI, 
            baseClassURI, 
            "/", 
            tokenId.toString(), 
            ".json"));
    }


    //mint next 1 token
    function safeMint(address to) external {
        //TODO require(_authorizedContracts[msg.sender], "No Auth");

        _safeMint(to, totalSupply());
    }

    //mint specific token
    function safeMint(address to, uint256 tokenID) external {
        //TODO require(_authorizedContracts[msg.sender], "No Auth");

        _safeMint(to, tokenID);
    }


    //mint next X tokens
    function safeBatchMint(address to, uint256 tokensToMint) external {
        //TODO require(_authorizedContracts[msg.sender], "No Auth");
        
        uint256 currentIndex = totalSupply();

        for (uint256 i = 0; i <= tokensToMint - 1; i++) {
            _safeMint(to, currentIndex + i);
        }
    }
    
    
    //------------------------------------------------------------------------------------
    // Utility Functions
    //------------------------------------------------------------------------------------


}