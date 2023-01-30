// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Multicall2 {
    // 0xd4502ad8
    error CallFailed();

    struct Call {
        address target;
        bytes callData;
    }

    struct Result {
        bool success;
        bytes returnData;
    }

    function aggregate(Call[] calldata calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        assembly {
            let len := calls.length
            mstore(returnData, len)
            let end := add(calls.offset, shl(5, len))
            let w := 0x20
            let offPointer := add(returnData, w)
            let offCounter := offPointer
            let pointer := add(offPointer, shl(5, len))

            for { let i := calls.offset } 1 {} {
                let offset := calldataload(i)
                let start := add(calls.offset, offset)
                let target := calldataload(start)
                let dOffset := add(start, w)
                let size := calldataload(add(dOffset, w))
                dOffset := add(dOffset, calldataload(dOffset))

                calldatacopy(pointer, dOffset, size)

                if iszero(call(gas(), target, 0, pointer, size, 0, 0)) {
                    mstore(0x00, 0xd4502ad8)
                    revert(0x1c, 0x04)
                }

                mstore(offPointer, sub(pointer, offCounter))
                mstore(pointer, returndatasize())
                returndatacopy(add(pointer, w), 0, returndatasize())

                pointer := add(pointer, and(0xffffffe0, add(returndatasize(), 0x3f)))

                i := add(i, w)

                if eq(i, end) { break }
                offPointer := add(offPointer, w)
            }
            mstore(0x40, 0x40)
            mstore(w, blockNumber)
            return(w, sub(pointer, w))
        }
    }

    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }

    function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
        blockHash = blockhash(blockNumber);
    }

    function getLastBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number - 1);
    }

    function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
        timestamp = block.timestamp;
    }

    function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
        difficulty = block.difficulty;
    }

    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }

    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }

    function blockAndAggregate(Call[] calldata calls)
        public
        returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData)
    {
        (blockNumber, blockHash, returnData) = tryBlockAndAggregate(true, calls);
    }

    function tryBlockAndAggregate(bool requireSuccess, Call[] calldata calls)
        public
        returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData)
    {
        blockNumber = block.number;
        blockHash = blockhash(block.number);
        assembly {
            let len := calls.length
            mstore(returnData, len)
            let end := add(calls.offset, shl(5, len))
            let w := 0x20
            let w2 := 0x40
            let offPointer := add(returnData, w)
            let offCounter := offPointer
            let pointer := add(offPointer, shl(5, len))

            for { let i := calls.offset } 1 {} {
                let offset := calldataload(i)
                let start := add(calls.offset, offset)
                let target := calldataload(start)
                let dOffset := add(start, w)
                let size := calldataload(add(dOffset, w))
                dOffset := add(dOffset, calldataload(dOffset))

                calldatacopy(pointer, dOffset, size)
                let success := call(gas(), target, 0, pointer, size, 0, 0)

                if requireSuccess {
                    if iszero(success) {
                        mstore(0x00, 0xd4502ad8)
                        revert(0x1c, 0x04)
                    }
                }

                mstore(offPointer, sub(pointer, offCounter))
                mstore(pointer, success)
                mstore(add(pointer, w), w2)
                mstore(add(pointer, w2), returndatasize())
                returndatacopy(add(pointer, add(w2, w)), 0, returndatasize())
                pointer := add(pointer, and(0xffffffe0, add(returndatasize(), 0x7f)))
                i := add(i, w)
                if eq(i, end) { break }
                offPointer := add(offPointer, w)
            }
            mstore(0, number())
            mstore(w, blockhash(number()))
            mstore(w2, returnData)
            return(0, pointer)
        }
    }

    function tryAggregate(bool requireSuccess, Call[] calldata calls) public returns (Result[] memory returnData) {
        assembly {
            let len := calls.length
            mstore(returnData, len)
            let end := add(calls.offset, shl(5, len))
            let w := 0x20
            let w2 := 0x40
            let offPointer := add(returnData, w)
            let offCounter := offPointer
            let pointer := add(offPointer, shl(5, len))

            for { let i := calls.offset } 1 {} {
                let offset := calldataload(i)
                let start := add(calls.offset, offset)
                let target := calldataload(start)
                let dOffset := add(start, w)
                let size := calldataload(add(dOffset, w))
                dOffset := add(dOffset, calldataload(dOffset))

                calldatacopy(pointer, dOffset, size)
                let success := call(gas(), target, 0, pointer, size, 0, 0)

                if requireSuccess {
                    if iszero(success) {
                        mstore(0x00, 0xd4502ad8)
                        revert(0x1c, 0x04)
                    }
                }

                mstore(offPointer, sub(pointer, offCounter))
                mstore(pointer, success)
                mstore(add(pointer, w), w2)
                mstore(add(pointer, w2), returndatasize())
                returndatacopy(add(pointer, add(w2, w)), 0, returndatasize())
                pointer := add(pointer, and(0xffffffe0, add(returndatasize(), 0x7f)))
                i := add(i, w)
                if eq(i, end) { break }
                offPointer := add(offPointer, w)
            }
            mstore(w2, w)
            return(w2, sub(pointer, w2))
        }
    }
}
