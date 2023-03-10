// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./iTokenMinter.sol";
import "./iDoAProxy.sol";
import "./DoAProxy.sol";


contract TokenMinter is iTokenMinter, Ownable, Pausable, ReentrancyGuard {

    //--------------------------------------------------------------------------------
    //  Constants
    //--------------------------------------------------------------------------------


    //--------------------------------------------------------------------------------
    //  State Variables
    //--------------------------------------------------------------------------------
    iDoAProxy private _doaProxy;

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
    constructor(address doaProxyAddr) {
        _doaProxy = iDoAProxy(doaProxyAddr);
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
    function mintHeros(address to) external override whenNotPaused nonReentrant {

        //TODO
        _doaProxy.safeMint(to, "");
    }
}