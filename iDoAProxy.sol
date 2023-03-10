// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;



import "@openzeppelin/contracts/access/Ownable.sol";

import "./iDoACollection.sol"; 
import "./iTokenMinter.sol";


interface iDoAProxy is iDoACollection, iTokenMinter {
    
}