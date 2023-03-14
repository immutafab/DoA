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
    using Counters for Counters.Counter;
    using Strings for uint256;
    

    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------
    Counters.Counter private _tokenIdCounter;
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

    
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        string memory baseClassURI;

        if (tokenId >= DoAConstants.HERO_NFT_START_INDEX && tokenId < DoAConstants.LEGEND_NFT_START_INDEX) {
            baseClassURI = DoAConstants.BASE_HERO_URI;

        } else if (tokenId >= DoAConstants.LEGEND_NFT_START_INDEX && tokenId < DoAConstants.RARE_NFT_START_INDEX) {
            baseClassURI = DoAConstants.BASE_LEGEND_URI;

        } else if (tokenId >= DoAConstants.RARE_NFT_START_INDEX && tokenId < DoAConstants.UNCOMMON_START_INDEX) {
            baseClassURI = DoAConstants.BASE_RARE_URI;

        } else if (tokenId >= DoAConstants.UNCOMMON_START_INDEX && tokenId < DoAConstants.COMMON_START_INDEX) {
            baseClassURI = DoAConstants.BASE_UNCOMMON_URI;

        } else if (tokenId >= DoAConstants.COMMON_START_INDEX) {
            baseClassURI = DoAConstants.BASE_COMMON_URI;

        } else {
            revert("Invalid tokenId");
        }

        return string(abi.encodePacked(baseURI, baseClassURI, "/", tokenId.toString(), ".json"));
    }


    function safeMint(address to) external {
        //require(_authorizedContracts[msg.sender], "No Auth");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }


    function safeBatchMint(address to, uint256[] memory tokenIds) external {
        //require(_authorizedContracts[msg.sender], "No Auth");
        
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _safeMint(to, tokenIds[i]);
        }
    }
    
    
}