// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Mutlicaller {
    // 0xd4502ad8
    error CallFailed();

    struct Call {
        address target;
        bytes callData;
    }

    // 0xe4fb3e07
    // 0000000000000000000000000000000000000000000000000000000000000020
    // 0000000000000000000000000000000000000000000000000000000000000001
    // 0000000000000000000000000000000000000000000000000000000000000020
    // 00000000000000000000000097fab8cb81f4593158615474a3a546aa3857a96f
    // 0000000000000000000000000000000000000000000000000000000000000040
    // 0000000000000000000000000000000000000000000000000000000000000024
    // 4f8dd50d00000000000000000000000000000000000000000000000000000000
    // 0000000500000000000000000000000000000000000000000000000000000000

    // [["0xf8e81D47203A594245E36C48e151709F0C19fBe8", "0x448fb29c0000000000000000000000000000000000000000000000000000000000000002"], ["0xf8e81D47203A594245E36C48e151709F0C19fBe8","0xaa5c5cb20000000000000000000000000000000000000000000000000000000000000003"]]


    // 0xe4fb3e07                                                                       - 0
    //  0000000000000000000000000000000000000000000000000000000000000020                - 4
    //  0000000000000000000000000000000000000000000000000000000000000002 - 0x20         - 24
    //  0000000000000000000000000000000000000000000000000000000000000040 - 0x40         - 44  
    //  00000000000000000000000000000000000000000000000000000000000000e0 - 0x60        
    //  00000000000000000000000097fab8cb81f4593158615474a3a546aa3857a96f - 0x80
    //  0000000000000000000000000000000000000000000000000000000000000040 - 0xa0
    //  0000000000000000000000000000000000000000000000000000000000000024 - 0xc0
    //  4f8dd50d00000000000000000000000000000000000000000000000000000000 - 0xe0
    //  0000000500000000000000000000000000000000000000000000000000000000 - 0x100
    //  00000000000000000000000097fab8cb81f4593158615474a3a546aa3857a96f - 0x120
    //  0000000000000000000000000000000000000000000000000000000000000040 - 0x140
    //  0000000000000000000000000000000000000000000000000000000000000024 - 0x160
    //  4f8dd50d00000000000000000000000000000000000000000000000000000000 - 0x180
    //  0000000500000000000000000000000000000000000000000000000000000000 - 0x1a0


    // 0xd4502ad8                                                       - 3
    // 0000000000000000000000000000000000000000000000000000000000000020 - 23
    // 0000000000000000000000000000000000000000000000000000000000000002 - 43
    // 0000000000000000000000000000000000000000000000000000000000000040 - 63
    // 00000000000000000000000000000000000000000000000000000000000000c0 - 83
    // 0000000000000000000000000000000000000000000000000000000000000001 - a3
    // 0000000000000000000000000000000000000000000000000000000000000040 - c3
    // 0000000000000000000000000000000000000000000000000000000000000004 - e3
    // d46300fd00000000000000000000000000000000000000000000000000000000 - 103
    // 0000000000000000000000000000000000000000000000000000000000000001 - 123
    // 0000000000000000000000000000000000000000000000000000000000000040 - 143
    // 0000000000000000000000000000000000000000000000000000000000000004 - 163
    // a1c5191500000000000000000000000000000000000000000000000000000000 - 183

    // 0x53b9af97
    // 0000000000000000000000000000000000000000000000000000000000000020
    // 0000000000000000000000000000000000000000000000000000000000000003
    // 0000000000000000000000000000000000000000000000000000000000000060
    // 00000000000000000000000000000000000000000000000000000000000000a0
    // 00000000000000000000000000000000000000000000000000000000000000e0
    // 0000000000000000000000000000000000000000000000000000000000000004
    // 1111111100000000000000000000000000000000000000000000000000000000
    // 0000000000000000000000000000000000000000000000000000000000000004
    // 2222222200000000000000000000000000000000000000000000000000000000
    // 0000000000000000000000000000000000000000000000000000000000000004
    // // 3333333300000000000000000000000000000000000000000000000000000000
    // function aggregate(Call[] calldata calls) public returns (bytes[] memory returnData) {
    //     // returnData = new bytes[](0);
    //     // blockNumber = block.number;
    //     // returnData = new bytes[](calls.length);
    //     // for(uint256 i = 0; i < calls.length; i++) {
    //     //     (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
    //     //     require(success);
    //     //     returnData[i] = ret;
    //     // }
    //     // blockNumber = block.number;

    //     assembly{
    //         let len := calls.length
    //         // mstore(returnData, 32)
    //         if len{

    //             returnData := mload(0x40)
    //             mstore(returnData, len)

    //             let end := add(calls.offset, shl(5, len))        // 
    //             let w := 0x20

    //             let offPointer := add(returnData, w)           // 80
    //             let offCounter := offPointer
    //             let pointer := add(offPointer, shl(5, len))      // 80 + 2*20 = c0 

    //             for { let i := calls.offset } 1 {} {      // 44 | 64
    //                 let offset := calldataload(i)          //40     | c0 
    //                 let target := calldataload(add(calls.offset, offset)) // 44 , 40 = 84   | 44 , c0 = 124 


    //                                                                                                   // | 44 , c0, 20 = 144 = 4 + 144 = 148      
    //                 // let bOffset := add(add(add(calls.offset, offset), w), calldataload(add(add(calls.offset, offset), w))) // 44 , 40 , 20 = callload(a4) = 40 + a4 = e4
    //                 let size := calldataload(add(add(calls.offset, offset), shl(1,w))) // 4
    //                 let bOffset := add(add(add(calls.offset, offset), w), calldataload(add(add(calls.offset, offset), w)))

    //                 calldatacopy(pointer, bOffset, size) 

    //                 if iszero(call(gas(), target, 0, pointer, size, 0 , 0)) {
    //                     mstore(0x00, 0xd4502ad8)
    //                     revert(0x1c, 0x04)
    //                 }

    //                 mstore(offPointer, sub(pointer, offCounter))            //s 184
    //                 mstore(pointer, returndatasize())
    //                 returndatacopy(add(pointer, w), 0, returndatasize())

    //                 pointer := add(add(pointer, shl(5, shr(5, add(returndatasize(), 0x1f)))), 0x20)
    //                 offPointer := add(offPointer, w)
    //                 i := add(i, w)        // 64
    //                 if iszero(lt(i,end)) {
    //                     break
    //                 }
    //             }
    //             mstore(0x40, pointer)
    //         }
    //     }
    // }



   function aggregate(Call[] calldata calls) public returns (bytes[] memory returnData) {
            assembly {
                let len := calls.length

                if len {
                    returnData := mload(0x40)
                    mstore(returnData , len)
                    let end := add(calls.offset, shl(5, len))
                    let w := 0x20
                    
                    let offPointer := add(returnData, w)
                    let offCounter := offPointer

                    let pointer := add(offPointer, shl(5 , len))

                    let i:= calls.offset

                    for { } 1 { } {
                        let offset := calldataload(i)

                        let start := add(calls.offset, offset)
                        let target := calldataload(start)

                        let dOffset := add(start, w)
                        let size := calldataload(add(dOffset,w))
                        dOffset := add(dOffset, calldataload(dOffset))

                        calldatacopy(pointer, dOffset, size)

                        if iszero(call(gas(), target, 0, pointer, size, 0, 0)){
                            mstore(0x00, 0xd4502ad8)
                            revert(0x1c, 0x04)
                        }

                        mstore(offPointer, sub(pointer, offCounter))
                        mstore(pointer, returndatasize())
                        returndatacopy(add(pointer, w), 0, returndatasize())
                        pointer :=  add(pointer, shl(5, shr(5, add(returndatasize(), 0x3f))))
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




    function original(Call[] calldata calls) public returns(bytes[] memory returnData){
        returnData = new bytes[](calls.length);
        for(uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
            require(success);
            returnData[i] = ret;
        }
    }




    function akshay(address target) public returns(bytes[] memory returnData) {
        // assembly {
        //     if iszero(call(gas(), target, 0, ))
        // }
    }
}



// Answer : 
// 0000000000000000000000000000000000000000000000000000000000000020
// 0000000000000000000000000000000000000000000000000000000000000002
// 0000000000000000000000000000000000000000000000000000000000000040
// 0000000000000000000000000000000000000000000000000000000000000060
// 0000000000000000000000000000000000000000000000000000000000000000
// 0000000000000000000000000000000000000000000000000000000000000000



// original

// 0000000000000000000000000000000000000000000000000000000000000020
// 0000000000000000000000000000000000000000000000000000000000000002
// 0000000000000000000000000000000000000000000000000000000000000040
// 0000000000000000000000000000000000000000000000000000000000000080
// 0000000000000000000000000000000000000000000000000000000000000020
// 00000000000000000000000000000000000000000000000000000000000000ff
// 0000000000000000000000000000000000000000000000000000000000000020
// 0000000000000000000000000000000000000000000000000000000000000012