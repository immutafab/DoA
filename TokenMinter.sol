// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./iTokenMinter.sol";
import "./DoAConstants.sol";
import "./iDoACollection.sol";
import "./iTreasury.sol";
import "./iMemberRegistry.sol";


contract TokenMinter is iTokenMinter, Ownable, Pausable, ReentrancyGuard {
    using Counters for Counters.Counter;



    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------
    iDoACollection private _doaCollection;
    iTreasury private _treasury;
    iMemberRegistry private _memberRegistry;

    mapping(address => bool) private _authorizedContracts;   //contracts that are allowed to call this


    //# sold NFTs
    Counters.Counter public _heroNFTsMinted;
    Counters.Counter public _legendNFTsMinted;
    Counters.Counter public _rareNFTsMinted;
    Counters.Counter public _uncommonNFTsMinted;
    Counters.Counter public _commonNFTsMinted;


    //# round control
    bool public _areHerosMinted;
    bool public _is1stPublicRoundUnlocked;
    bool public _is2ndPublicRoundUnlocked;
    bool public _is3rdPublicRoundUnlocked;



    //--------------------------------------------------------------------------------
    // Utility functions
    //--------------------------------------------------------------------------------
    

    //--------------------------------------------------------------------------------
    // Modifiers
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    // Events
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------------------------

    constructor(address doaCollectionAddress, address treasuryAddress, address memberRegistryAddress)  {
        _doaCollection = iDoACollection(doaCollectionAddress);
        _treasury = iTreasury(treasuryAddress);
        _memberRegistry = iMemberRegistry(memberRegistryAddress);

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



    //--------------------------------------------------------------------------------
    // Functions: DoA Internal
    //--------------------------------------------------------------------------------
    
    function unlock1stPublicRound() external  whenNotPaused nonReentrant {
        require(_authorizedContracts[msg.sender], "No Auth");
        require(!_is1stPublicRoundUnlocked, "Already unlocked");

        require(_areHerosMinted, "Heros not minted");

        _is1stPublicRoundUnlocked = true;
    }


    function unlock2ndPublicRound() external  whenNotPaused nonReentrant {
        require(_authorizedContracts[msg.sender], "No Auth");
        require(!_is2ndPublicRoundUnlocked, "Already unlocked");

        //check if there are any NFTs left to mint
        require(_areHerosMinted, "Heros not minted");
        require(_is1stPublicRoundUnlocked && uint16(_legendNFTsMinted.current()) < DoAConstants.LEGEND_NFT_SUPPLY_1st, "Unminted legends");
        require(_is1stPublicRoundUnlocked && uint16(_rareNFTsMinted.current()) < DoAConstants.RARE_NFT_SUPPLY_1st, "Unminted rares");
        require(_is1stPublicRoundUnlocked && uint16(_uncommonNFTsMinted.current()) < DoAConstants.UNCOMMON_NFT_SUPPLY_1st, "Unminted uncommons");
        require(_is1stPublicRoundUnlocked && uint16(_commonNFTsMinted.current())< DoAConstants.COMMON_NFT_SUPPLY_1st, "Unminted commons");

        _is2ndPublicRoundUnlocked = true;
        _is1stPublicRoundUnlocked = false;  //relock 1st round
    }

    //mint 25 heros
    function mintHeros(address toAddr) external  whenNotPaused nonReentrant {
        require(_authorizedContracts[msg.sender], "No Auth");
        require(!_areHerosMinted, "Already minted");

        uint256 numMinted = _mintNFTs(toAddr, DoAConstants.HERO_NFT_SUPPLY_1st, NFT_CLASS.HERO);

        if(numMinted == DoAConstants.HERO_NFT_SUPPLY_1st)
            _areHerosMinted = true;

    }


    function getMintIndexRange(uint256 numToMint, NFT_CLASS classToMint) public view whenNotPaused returns (uint256 mintStartIndex, uint256 mintEndIndex) {
        require(numToMint > 0, "numToMint 0");
        require(_areHerosMinted, "Heros not minted");

        uint16 currentCount;
        uint16 futureCount;
        uint256 classNFTSupply_1st;
        uint256 classNFTSupply_2nd;
        uint256 classNFTSupply_3rd;
        

        //set class specific variables
        if(classToMint == NFT_CLASS.LEGEND) {
                currentCount = uint16(_legendNFTsMinted.current());
                futureCount = currentCount + uint16(numToMint);

                classNFTSupply_1st = DoAConstants.LEGEND_NFT_SUPPLY_1st;
                classNFTSupply_2nd = DoAConstants.LEGEND_NFT_SUPPLY_2nd;
                classNFTSupply_3rd = DoAConstants.LEGEND_NFT_SUPPLY_3rd;

                mintStartIndex = DoAConstants.LEGEND_NFT_START_INDEX + currentCount;
                mintEndIndex = DoAConstants.LEGEND_NFT_START_INDEX + futureCount - 1;
        }
        else if(classToMint == NFT_CLASS.RARE) {
                currentCount = uint16(_rareNFTsMinted.current());
                futureCount = currentCount + uint16(numToMint);

                classNFTSupply_1st = DoAConstants.RARE_NFT_SUPPLY_1st;
                classNFTSupply_2nd = DoAConstants.RARE_NFT_SUPPLY_2nd;
                classNFTSupply_3rd = DoAConstants.RARE_NFT_SUPPLY_3rd;

                mintStartIndex = DoAConstants.RARE_NFT_START_INDEX + currentCount;
                mintEndIndex = DoAConstants.RARE_NFT_START_INDEX + futureCount - 1;
        }
        else if(classToMint == NFT_CLASS.UNCOMMON) {
                currentCount = uint16(_uncommonNFTsMinted.current());
                futureCount = currentCount + uint16(numToMint);

                classNFTSupply_1st = DoAConstants.UNCOMMON_NFT_SUPPLY_1st;
                classNFTSupply_2nd = DoAConstants.UNCOMMON_NFT_SUPPLY_2nd;
                classNFTSupply_3rd = DoAConstants.UNCOMMON_NFT_SUPPLY_3rd;

                mintStartIndex = DoAConstants.UNCOMMON_NFT_START_INDEX + currentCount;
                mintEndIndex = DoAConstants.UNCOMMON_NFT_START_INDEX + futureCount - 1;
        }
        else if(classToMint == NFT_CLASS.COMMON) {
                currentCount = uint16(_commonNFTsMinted.current());
                futureCount = currentCount + uint16(numToMint);

                classNFTSupply_1st = DoAConstants.COMMON_NFT_SUPPLY_1st;
                classNFTSupply_2nd = DoAConstants.COMMON_NFT_SUPPLY_2nd;
                classNFTSupply_3rd = DoAConstants.COMMON_NFT_SUPPLY_3rd;

                mintStartIndex = DoAConstants.COMMON_NFT_START_INDEX + currentCount;
                mintEndIndex = DoAConstants.COMMON_NFT_START_INDEX + futureCount - 1;
                
        } 
        else revert("Invalid class");


        //check supply of Class NFTs
        if(_is1stPublicRoundUnlocked) 
            require(futureCount <= classNFTSupply_1st, "supply insufficient");
        else if(_is2ndPublicRoundUnlocked) 
            require(futureCount <= classNFTSupply_2nd, "supply insufficient");
        else if(_is3rdPublicRoundUnlocked)
            require(futureCount <= classNFTSupply_3rd, "supply insufficient");
        else
            revert("no public round unlocked");

    }


    function _mintNFTs(address toAddr, uint256 numToMint, NFT_CLASS classToMint) private whenNotPaused nonReentrant  returns (uint256 numMinted){ 
        require(_areHerosMinted, "Heros not minted");

        //require payment
        uint256 classNFTPrice = DoAConstants.getClassPrice(classToMint);
        //TODO require(msg.value >= classNFTPrice * numToMint, "Insufficient payment");


        (uint256 mintStartIndex, uint256 mintEndIndex) = 
            getMintIndexRange(numToMint, classToMint);


        uint256 actualMintEndIndex = mintStartIndex;

        //mint NFT
        for(uint256 currentIndex = mintStartIndex; currentIndex <= mintEndIndex; currentIndex++) {
            
            _doaCollection.safeMint(toAddr, currentIndex);
            _memberRegistry.nftMinted(toAddr, currentIndex);

            actualMintEndIndex = currentIndex;

            //update minted class counters
            if(classToMint == NFT_CLASS.LEGEND)
                _legendNFTsMinted.increment();
            else if(classToMint == NFT_CLASS.RARE)
                _rareNFTsMinted.increment();
            else if(classToMint == NFT_CLASS.UNCOMMON)
                _uncommonNFTsMinted.increment();
            else if(classToMint == NFT_CLASS.COMMON)
                _commonNFTsMinted.increment();
            else revert("Invalid class");

        }

        //send payment to treasury
        //TODO _treasury.depositNFTRevenue{value: msg.value} ();

        numMinted = actualMintEndIndex - mintStartIndex + 1;
    }


    function mintLegends(address toAddr, uint256 numToMint) external whenNotPaused  payable {
        _mintNFTs(toAddr, numToMint, NFT_CLASS.LEGEND);
    }

        
    function mintLegend(address toAddr) external  whenNotPaused  payable {
        _mintNFTs(toAddr, 1, NFT_CLASS.LEGEND);
    }


    function mintRares(address toAddr, uint256 numToMint) external  whenNotPaused  payable {
        _mintNFTs(toAddr, numToMint, NFT_CLASS.RARE);
    }

    function mintRare(address toAddr) external  whenNotPaused  payable {
        _mintNFTs(toAddr, 1, NFT_CLASS.RARE);
    }

    function mintUncommons(address toAddr, uint256 numToMint) external  whenNotPaused  payable {
        _mintNFTs(toAddr, numToMint, NFT_CLASS.UNCOMMON);
    }

    function mintUncommon(address toAddr) external  whenNotPaused  payable {
        _mintNFTs(toAddr, 1, NFT_CLASS.UNCOMMON);
    }

    function mintCommons(address toAddr, uint256 numToMint) external  whenNotPaused  payable {
        _mintNFTs(toAddr, numToMint, NFT_CLASS.COMMON);
    }

    function mintCommon(address toAddr) external  whenNotPaused  payable {
        _mintNFTs(toAddr, 1, NFT_CLASS.COMMON);
    }


    //------------------------------------------------------------------------------------
    // Utility
    //------------------------------------------------------------------------------------

   

}