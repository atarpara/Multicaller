// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Multicall {
    // 0xd4502ad8
    error CallFailed();

    struct Call {
        address target;
        bytes callData;
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
}
