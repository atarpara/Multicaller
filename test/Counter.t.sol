// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/multicall.sol";

contract A {
    function getA() public pure returns(uint256 ){
        return 255;
    }

    function getB() public pure returns(address){
        return address(0x12);
    }
}


contract Debugger is Test{

    Mutlicaller m;
    A a;
    function setUp() public {
        m = new Mutlicaller();
        a = new A();
    }
    event log(bytes ll);
    function testA() public {
        address _target = address(a);
        bytes[] memory returnData = new bytes[](2);
        returnData[0] = abi.encodeWithSignature("getA()");
        returnData[1] = abi.encodeWithSignature("getB()");

        Mutlicaller.Call[] memory cl = new Mutlicaller.Call[](2);
        cl[0] = Mutlicaller.Call({target : _target, callData : returnData[0]});
        cl[1] = Mutlicaller.Call({target : _target, callData : returnData[1]});

        (bool s, bytes memory kk) = address(m).call(abi.encodeWithSignature("aggregate((address,bytes)[])", cl));
        require(s);
        emit log(kk);
    }
}