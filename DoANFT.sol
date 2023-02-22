// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DoA is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable, EIP712, ERC721Votes {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter; // Counter for the token IDs

    constructor() ERC721("DoA", "DOA") EIP712("DoA", "1") {} // Constructor function for the DoA contract that initializes the ERC721, EIP712 contracts

    function _baseURI() internal pure override returns (string memory) { // Function to return the base URI for token metadata
        return "https://ipfs-TBD"; // Returns the base URI for token metadata
    }

    function pause() public onlyOwner { // Function to pause the contract, can only be called by the owner
        _pause(); // Calls the built-in _pause() function to pause the contract
    }

    function unpause() public onlyOwner { // Function to unpause the contract, can only be called by the owner
        _unpause(); // Calls the built-in _unpause() function to unpause the contract
    }

    function safeMint(address to, string memory uri) public onlyOwner { // Function to safely mint a new token, can only be called by the owner
        uint256 tokenId = _tokenIdCounter.current(); // Gets the current token ID from the counter
        _tokenIdCounter.increment(); // Increments the token ID counter for the next token
        _safeMint(to, tokenId); // Safely mints a new token to the specified address
        _setTokenURI(tokenId, uri); // Sets the token URI for the new token
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize); // Calls the _beforeTokenTransfer function from the inherited ERC721 and ERC721Enumerable contracts
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId, batchSize); // Calls the _afterTokenTransfer function from the inherited ERC721 and ERC721Votes contracts
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId); // Calls the _burn function from the inherited ERC721 and ERC721URIStorage contracts
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId); // Calls the tokenURI function from the inherited ERC721 and ERC721URIStorage contracts
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId); // Calls the supportsInterface function from the inherited ERC721 and ERC721Enumerable contracts
    }
}