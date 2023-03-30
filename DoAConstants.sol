// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


//--------------------------------------------------------------------------------
//  Enums
//--------------------------------------------------------------------------------
enum NFT_CLASS {
    HERO,
    LEGEND,
    RARE,
    UNCOMMON,
    COMMON
}


   
//-----------------------------------------------------------------------------------
// Constants
//-----------------------------------------------------------------------------------

library DoAConstants {

    
    //--------------------------------------------------------------------------------
    //  Minting rounds & supply
    //--------------------------------------------------------------------------------
    
    //#  NFTs supply in 1st round
    uint16 public constant HERO_NFT_SUPPLY_1st = 25;
    uint16 public constant LEGEND_NFT_SUPPLY_1st = 1;
    uint16 public constant RARE_NFT_SUPPLY_1st = 5;
    uint16 public constant UNCOMMON_NFT_SUPPLY_1st = 25;
    uint16 public constant COMMON_NFT_SUPPLY_1st = 125;

    //#  NFTs supply in 2nd round
    uint16 public constant HERO_NFT_SUPPLY_2nd = 0;
    uint16 public constant LEGEND_NFT_SUPPLY_2nd = 10;
    uint16 public constant RARE_NFT_SUPPLY_2nd = 50;
    uint16 public constant UNCOMMON_NFT_SUPPLY_2nd = 250;
    uint16 public constant COMMON_NFT_SUPPLY_2nd = 1250;

    //#  NFTs supply in 3rd round
    uint16 public constant HERO_NFT_SUPPLY_3rd = 0;
    uint16 public constant LEGEND_NFT_SUPPLY_3rd = 80;
    uint16 public constant RARE_NFT_SUPPLY_3rd = 400;
    uint16 public constant UNCOMMON_NFT_SUPPLY_3rd = 2000;
    uint16 public constant COMMON_NFT_SUPPLY_3rd = 5770;

    //#  NFTs supply totals
    uint16 public constant NFT_SUPPLY_1st = 181;
    uint16 public constant NFT_SUPPLY_2nd = 1560;
    uint16 public constant NFT_SUPPLY_3rd = 8250;


    //--------------------------------------------------------------------------------
    // NFTs start indexes for first 10K NFTs
    //--------------------------------------------------------------------------------

    //#  NFT Type start indexes
    uint16 public constant HERO_NFT_START_INDEX = 0;
    uint16 public constant LEGEND_NFT_START_INDEX = 25;
    uint16 public constant RARE_NFT_START_INDEX = 126;
    uint16 public constant UNCOMMON_NFT_START_INDEX = 627;
    uint16 public constant COMMON_NFT_START_INDEX = 3128;



    //--------------------------------------------------------------------------------
    //  Minting prices
    //--------------------------------------------------------------------------------
 
    uint256 public constant LEGEND_NFT_PRICE = 1.64 ether; //~$2500
    uint256 public constant RARE_NFT_PRICE = 0.33 ether; //~$500
    uint256 public constant COMMON_NFT_PRICE = 0.066 ether; //~$100
    uint256 public constant UNCOMMON_NFT_PRICE = 0.013 ether; //~$20




    //--------------------------------------------------------------------------------
    // NFTs metadata
    //--------------------------------------------------------------------------------

    string public constant BASE_URI = "ipfs://<hash>/doa/nft";

    string public constant BASE_HERO_URI = "/hero/metadata";
    string public constant BASE_LEGEND_URI = "/legend/metadata";
    string public constant BASE_RARE_URI = "/rare/metadata";
    string public constant BASE_UNCOMMON_URI = "/uncommon/metadata";
    string public constant BASE_COMMON_URI = "/common/metadata";

    
    //--------------------------------------------------------------------------------
    // Treasury
    //--------------------------------------------------------------------------------
    uint8 public constant PUBLIC_FUND_PERCENTAGE = 60;


    
    // Returns NFT class for given token ID
    function getClassForTokenId(uint256 tokenId) public pure returns (NFT_CLASS tokenClass) {
        
        if (tokenId >= DoAConstants.HERO_NFT_START_INDEX && tokenId < DoAConstants.LEGEND_NFT_START_INDEX) {
            tokenClass = NFT_CLASS.HERO;
        } else if (tokenId >= DoAConstants.LEGEND_NFT_START_INDEX && tokenId < DoAConstants.RARE_NFT_START_INDEX) {
            tokenClass = NFT_CLASS.LEGEND;
        } else if (tokenId >= DoAConstants.RARE_NFT_START_INDEX && tokenId < DoAConstants.UNCOMMON_NFT_START_INDEX) {
            tokenClass = NFT_CLASS.RARE;
        } else if (tokenId >= DoAConstants.UNCOMMON_NFT_START_INDEX && tokenId < DoAConstants.COMMON_NFT_START_INDEX) {
            tokenClass = NFT_CLASS.UNCOMMON;
        } else if (tokenId >= DoAConstants.COMMON_NFT_START_INDEX) {
            tokenClass = NFT_CLASS.COMMON;
        } else {
            revert("Invalid token ID");
        }

        return tokenClass;
    }

    function getClassName(NFT_CLASS nftClass) public pure returns (string memory tokenClassName) {
        
        if (nftClass == NFT_CLASS.HERO) {
            tokenClassName = "Hero";
        } else if (nftClass == NFT_CLASS.LEGEND) {
            tokenClassName = "Legend";
        } else if (nftClass == NFT_CLASS.RARE) {
            tokenClassName = "Rare";
        } else if (nftClass == NFT_CLASS.UNCOMMON) {
            tokenClassName = "Uncommon";
        } else if (nftClass == NFT_CLASS.COMMON) {
            tokenClassName = "Common";
        } else {
            revert("Invalid token class");
        }

    } 


    function getClassPrice(NFT_CLASS nftClass) public pure returns (uint256 classNFTPrice) {
        if(nftClass == NFT_CLASS.LEGEND) 
            classNFTPrice = DoAConstants.LEGEND_NFT_PRICE;
        else if(nftClass == NFT_CLASS.RARE) 
            classNFTPrice = DoAConstants.RARE_NFT_PRICE;
        else if(nftClass == NFT_CLASS.UNCOMMON) 
            classNFTPrice = DoAConstants.UNCOMMON_NFT_PRICE;
        else if(nftClass == NFT_CLASS.COMMON) 
            classNFTPrice = DoAConstants.COMMON_NFT_PRICE;
        else revert("Invalid class");

        return classNFTPrice;
    }

    function testClassForTokenId(uint256 tokenId) public pure returns (string memory className) {
        return getClassName(getClassForTokenId(tokenId));
    }

}