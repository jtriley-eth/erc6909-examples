// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library ERC6909TransferLib {
    function transfer(
        address erc6909,
        address receiver,
        uint256 id,
        uint256 amount
    ) internal {
        assembly {
            // load free memory pointer to restore later
            let free_mem_ptr := mload(free_mem_ptr_slot)

            // store erc6909.transfer calldata
            // 0x00..0x04 : transfer selector (sig)
            // 0x04..0x24 : receiver address
            // 0x24..0x44 : id
            // 0x44..0x64 : amount
            mstore(sig_ptr, transfer_sig)
            mstore(arg_0_ptr, receiver)
            mstore(arg_1_ptr, id)
            mstore(arg_2_ptr, amount)

            // call erc6909.transfer, bubble up revert on error
            if iszero(call(gas(), erc6909, value, arg_ptr, transfer_arg_size, ret_ptr, ret_size)) {
                returndatacopy(zero, zero, returndatasize())
                revert(zero, returndatasize())
            }

            // restore free memory pointer and zero slot
            mstore(free_mem_ptr_slot, free_mem_ptr)
            mstore(zero_slot, zero)
        }
    }

    function transferFrom(
        address erc6909,
        address sender,
        address receiver,
        uint256 id,
        uint256 amount
    ) internal {
        assembly {
            // load free memory pointer and memory starting at `0x80` to restore later
            let free_mem_ptr := mload(free_mem_ptr_slot)
            let aux_mem := mload(aux_slot)

            // store erc6909.transferFrom calldata
            // 0x00..0x04 : transferFrom selector (sig)
            // 0x04..0x24 : sender address
            // 0x24..0x44 : receiver address
            // 0x44..0x64 : id
            // 0x64..0x84 : amount
            mstore(sig_ptr, transfer_from_sig)
            mstore(arg_0_ptr, sender)
            mstore(arg_1_ptr, receiver)
            mstore(arg_2_ptr, id)
            mstore(arg_3_ptr, amount)

            // call erc6909.transferFrom, bubble up revert on error
            if iszero(call(gas(), erc6909, value, arg_ptr, transfer_from_arg_size, ret_ptr, ret_size)) {
                returndatacopy(zero, zero, returndatasize())
                revert(zero, returndatasize())
            }

            // restore free memory pointer, zero slot, and memory starting at `0x80`
            mstore(free_mem_ptr_slot, free_mem_ptr)
            mstore(zero_slot, zero)
            mstore(aux_slot, aux_mem)
        }
    }
}

// free memory pointer slot
uint256 constant free_mem_ptr_slot = 0x40;
// zeroed memory slot
uint256 constant zero_slot = 0x60;
// slot of memory starting at `0x80`
uint256 constant aux_slot = 0x80;

// zero
uint256 constant zero = 0x00;

// selector pointer
uint256 constant sig_ptr = 0x00;

// first argument pointer
uint256 constant arg_0_ptr = 0x04;

// second argument pointer
uint256 constant arg_1_ptr = 0x24;

// third argument pointer
uint256 constant arg_2_ptr = 0x44;

// fourth argument pointer
uint256 constant arg_3_ptr = 0x64;

// msg value to send (always zero)
uint256 constant value = 0x00;

// arguments pointer
uint256 constant arg_ptr = 0x00;

// returndata pointer
uint256 constant ret_ptr = 0x00;

// returndata size
uint256 constant ret_size = 0x00;

// transfer signature and argument size
uint256 constant transfer_sig = 0x095bcdb600000000000000000000000000000000000000000000000000000000;
uint256 constant transfer_arg_size = 0x64;

// transferFrom signature and argument size
uint256 constant transfer_from_sig = 0xfe99049a00000000000000000000000000000000000000000000000000000000;
uint256 constant transfer_from_arg_size = 0x84;
