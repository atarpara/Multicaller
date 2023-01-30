// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import "src/Multicall.sol";
import "./Mock/MockMulticall.sol";

contract A {
    function getA() public pure returns (uint256) {
        return 255;
    }

    function getB() public pure returns (address) {
        return address(0x12);
    }
}

contract B {
    function getRevert() public pure returns (uint256) {
        revert("");
    }

    function getRevertWithData() public pure returns (address) {
        revert("Failed");
    }
}

contract Multicall2Test is Test {
    Multicall2 m;
    A a;
    B b;

    function setUp() public {
        m = new Multicall2();
        a = new A();
        b = new B();
    }

    event log(bytes ans);

    function testA() public {
        address _target = address(a);
        bytes[] memory returnData = new bytes[](2);
        returnData[0] = abi.encodeWithSignature("getA()");
        returnData[1] = abi.encodeWithSignature("getB()");

        Multicall2.Call[] memory cl = new Multicall2.Call[](2);
        cl[0] = Multicall2.Call({target: _target, callData: returnData[0]});
        cl[1] = Multicall2.Call({target: _target, callData: returnData[1]});

        (bool s, bytes memory kk) =
            address(m).call(abi.encodeWithSignature("tryBlockAndAggregate(bool,(address,bytes)[])", false, cl));
        (bool s1, bytes memory kk1) =
            address(m).call(abi.encodeWithSignature("original(bool,(address,bytes)[])", false, cl));

        require(s);
        require(s1);
        //    emit log(kk1);
        //    emit log(kk);

        require(keccak256(kk) == keccak256(kk1));
    }
}
