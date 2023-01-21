// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./Multicall.sol";

contract Multicall2 is Multicall {

    struct Result {
        bool success;
        bytes returnData;
    }

    function blockAndAggregate(Call[] calldata calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
        (blockNumber, blockHash, returnData) = tryBlockAndAggregate(true, calls);
    }

    function tryBlockAndAggregate(bool requireSuccess, Call[] calldata calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
        blockNumber = block.number;
        blockHash = blockhash(block.number);
        returnData = tryAggregate(requireSuccess, calls);
    }

    function tryAggregate(bool requireSuccess, Call[] calldata calls) public returns (Result[] memory returnData) {
        assembly{
            let len := calls.length
            mstore(returnData , len)
            let end := add(calls.offset, shl(5, len))
            let w := 0x20
            let w2 := 0x40
            let offPointer := add(returnData, w)
            let pointer := add(offPointer, shl(5 , len))

            for { let i:= calls.offset } 1 { } {

                let offset := calldataload(i)
                let start := add(calls.offset, offset)
                let target := calldataload(start)
                let dOffset := add(start, w)
                let size := calldataload(add(dOffset,w))
                dOffset := add(dOffset, calldataload(dOffset))

                calldatacopy(pointer, dOffset, size)
                

                let s := call(gas(), target, 0, pointer, size, 0, 0)

                if requireSuccess {
                    if iszero(s) {
                        mstore(0x00, 0xd4502ad8)
                        revert(0x1c, 0x04)
                    }
                }

                mstore(offPointer, pointer)
                mstore(pointer, s)
                mstore(add(pointer,w), add(pointer, w2))
                mstore(add(pointer, w2), returndatasize())

                returndatacopy(add(add(pointer, w2), w), 0, returndatasize())

                pointer := add(pointer, and(0xffffffe0, add(returndatasize(), 0x7f)))

                offPointer := add(offPointer, w)
                i := add(i ,w)
                
                if eq(i, end) {
                    break
                }
            }
            mstore(0x40, pointer)
        }
    }

}