// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
// import "src/Multicall.sol";
import "src/Multicall.sol";


contract A {
    function getA() public pure returns(uint256 ){
        return 255;
    }

    function getB() public pure returns(address){
        return address(0x12);
    }
}


contract B {
    function getRevert() public pure returns(uint256 ){
        revert("");
    }

    function getRevertWithData() public pure returns(address){
        revert("Failed");
    }
}


contract Multicall is Test{

    Multicall m;
    A a;
    B b;
    function setUp() public {
        m = new Multicall();
        a = new A();
        b - new B();
    }

    function testA() public {
        address _target = address(a);
        bytes[] memory returnData = new bytes[](2);
        returnData[0] = abi.encodeWithSignature("getA()");
        returnData[1] = abi.encodeWithSignature("getB()");

        Multicall.Call[] memory cl = new Multicall.Call[](2);
        cl[0] = Multicall.Call({target : _target, callData : returnData[0]});
        cl[1] = Multicall.Call({target : _target, callData : returnData[1]});

        (bool s, bytes memory kk) = address(m).call(abi.encodeWithSignature("aggregate(bool,(address,bytes)[])", true, cl));

        require(s);
       
    }
}