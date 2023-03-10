// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./bak/iHelloWorld.sol";


contract HelloWorldProxy is iHelloWorld {

    address private _helloWorldAddr;

    //function sayHelloWorld() external pure returns (string memory) {
      //  return "Hello World";
    //}
    
    //constructor(address helloWorldAddr) {
     //   _helloWorldAddr = helloWorldAddr;
    //}

    function setHelloWorldAddr(address helloWorldAddr) external {
        _helloWorldAddr = helloWorldAddr;
    }

    function staticCallWReturn(address _target, bytes memory _data) internal view returns (bytes memory) {
       (bool _success, bytes memory _returndata) = _target.staticcall(_data);
        if (!_success) {
            if (_returndata.length == 0) revert();
            assembly {
                revert(add(32, _returndata), mload(_returndata))
            }
        }
        return _returndata;
    }


   function sayHelloWorld() external view returns (string memory) {
        require(_helloWorldAddr != address(0), "HelloWorldProxy: helloWorldAddr is not set");
       
        return abi.decode(staticCallWReturn(_helloWorldAddr, abi.encodeWithSignature("sayHelloWorld()")), (string));
   }
        


}