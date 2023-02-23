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
    using Strings for string;

    //--------------------------------------------------------------------------------
    //  Enums
    //--------------------------------------------------------------------------------
    enum NFT_TYPE {
        Hero,
        Legend,
        Rare,
        Uncommon,
        Common
    }


    //--------------------------------------------------------------------------------
    //  Constants
    //--------------------------------------------------------------------------------
    //fund distribution
    uint256 constant PUBLIC_FUND_PERCENTAGE = 60; //60%
    uint256 constant PRIVATE_FUND_PERCENTAGE = 40; //40%

    //#  NFTs supply in 1st round
    uint256 constant HERO_NFT_SUPPLY_1st = 25;
    uint256 constant LEGEND_NFT_SUPPLY_1st = 1;
    uint256 constant RARE_NFT_SUPPLY_1st = 5;
    uint256 constant UNCOMMON_NFT_SUPPLY_1st = 25;
    uint256 constant COMMON_NFT_SUPPLY_1st = 125;

    //#  NFTs supply in 2nd round
    uint256 constant HERO_NFT_SUPPLY_2nd = 0;
    uint256 constant LEGEND_NFT_SUPPLY_2nd = 10;
    uint256 constant RARE_NFT_SUPPLY_2nd = 50;
    uint256 constant UNCOMMON_NFT_SUPPLY_2nd = 250;
    uint256 constant COMMON_NFT_SUPPLY_2nd = 1250;

    //#  NFTs supply in 3rd round
    uint256 constant HERO_NFT_SUPPLY_3rd = 0;
    uint256 constant LEGEND_NFT_SUPPLY_3rd = 80;
    uint256 constant RARE_NFT_SUPPLY_3rd = 400;
    uint256 constant UNCOMMON_NFT_SUPPLY_3rd = 2000;
    uint256 constant COMMON_NFT_SUPPLY_3rd = 5770;

    //#  NFTs supply totals
    uint256 constant NFT_SUPPLY_1st = 181;
    uint256 constant NFT_SUPPLY_2nd = 1560;
    uint256 constant NFT_SUPPLY_3rd = 8250;

    //#  NFT Type start indexes
    uint256 constant HERO_NFT_START_INDEX = 1;
    uint256 constant LEGEND_NFT_START_INDEX = 26;
    uint256 constant RARE_NFT_START_INDEX = 127;
    uint256 constant UNCOMMON_START_INDEX = 628;
    uint256 constant COMMON_START_INDEX = 3129;

    //# pricing
    uint256 constant LEGEND_NFT_PRICE = 1.64 ether; //~$2500
    uint256 constant RARE_NFT_PRICE = 0.33 ether; //~$500
    uint256 constant COMMON_NFT_PRICE = 0.066 ether; //~$100
    uint256 constant UNCOMMON_NFT_PRICE = 0.013 ether; //~$20

    string constant BASE_URI = "ipfs://<hash>/doa/nft";
    string constant BASE_HERO_URI = "/hero/metadata";

    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------

    //map collectionID to NFT type
    mapping(uint256 => NFT_TYPE) private _collectionIDToNFTType;
   
    Counters.Counter private _tokenIdCounter; // Counter for the token IDs

    //# sold NFTs
    Counters.Counter private _legendNFTCounter;
    Counters.Counter private _rareNFTCounter;
    Counters.Counter private _uncommonNFTCounter;
    Counters.Counter private _commonNFTCounter;

    //# state variable
    string constant BASE_EXTENSION = ".json";
    address payable private _publicFund;
 

    //# round control
    bool private _is1stPublicRoundUnlocked;
    bool private _is2ndPublicRoundUnlocked;
    bool private _is3rdPublicRoundUnlocked;
    bool private _areHerosMinted;



    //--------------------------------------------------------------------------------
    // Utility functions
    //--------------------------------------------------------------------------------
    function concat(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }


    //--------------------------------------------------------------------------------
    // Modifiers
    //--------------------------------------------------------------------------------
    bool private _locked;

    modifier nonReentrant() {
        require(!_locked, "Function is locked");
        _locked = true;
        _; // This is the function body placeholder
        _locked = false;
    }
    
    modifier checkLegendNFTPayment() {
        require(
            msg.value >= LEGEND_NFT_PRICE,
            concat("Insufficient value: Legend NFTs cost ", concat(toString(LEGEND_NFT_PRICE), " ether"))
        );
        _;  // This is the function body placeholder
    }

   modifier checkRareNFTPayment() {
        require(
            msg.value >= RARE_NFT_PRICE,
            concat("Insufficient value: Rare NFTs cost ", concat(toString(RARE_NFT_PRICE), " ether"))
        );
        _; // This is the function body placeholder
    }

    modifier checkUncommonNFTPayment() {
        require(
            msg.value >= UNCOMMON_NFT_PRICE,
            concat("Insufficient value: Uncommon NFTs cost ", concat(toString(UNCOMMON_NFT_PRICE), " ether"))
        );
        _; // This is the function body placeholder
    }

    modifier checkCommonNFTPayment() {
        require(
            msg.value >= COMMON_NFT_PRICE,
            concat("Insufficient value: Common NFTs cost ", concat(toString(COMMON_NFT_PRICE), " ether"))
        );
        _; // This is the function body placeholder
    }




    //--------------------------------------------------------------------------------
    // Events
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    //  Constructor
    //--------------------------------------------------------------------------------
    constructor() ERC721("DoA", "DOA") EIP712("DoA", "1") {} // Constructor function for the DoA contract that initializes the ERC721, EIP712 contracts


    //--------------------------------------------------------------------------------
    // Base ERC721 Overrides
    //--------------------------------------------------------------------------------
    function _baseURI() internal pure override returns (string memory) { // Function to return the base URI for token metadata
        return BASE_URI; // Returns the base URI for token metadata
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




    //--------------------------------------------------------------------------------
    //  Public DOA Functions
    //--------------------------------------------------------------------------------

    //mint Legend NFTs
    //must be done before any thing else
    function mintHeros()
        public
        onlyOwner
        whenNotPaused
        nonReentrant
    {
        require(!_areHerosMinted, concat("All ", concat( (toString(HERO_NFT_SUPPLY_1st)), " Heros have been minted")));
        //id 1-25 NFTs
        for (uint256 i = HERO_NFT_START_INDEX; i <= HERO_NFT_SUPPLY_1st; i++) {
            _safeMint(msg.sender, i);
            _setTokenURI(i, concat(BASE_URI, concat(BASE_HERO_URI, concat( toString(i), (BASE_EXTENSION)) )));
            _collectionIDToNFTType[i] = NFT_TYPE.Hero;
        }
        _areHerosMinted = true;
    }


    function unlock1stPublicRound() external onlyOwner whenNotPaused {
        require(
            _is1stPublicRoundUnlocked != true,
            "1st round is already started"
        );
        require(_areHerosMinted, "Hero NFTs are not Minted yet!");

        _is1stPublicRoundUnlocked = true;
    }
}