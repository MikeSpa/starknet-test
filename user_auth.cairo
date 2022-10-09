// Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_nn


// A map from user (represented by account contract address)
// to their balance.
@storage_var
func balance(user: felt) -> (res: felt) {
}
//signature of balance.read() and balance.write():
// func read{
//     syscall_ptr: felt*,
//     range_check_ptr,
//     pedersen_ptr: HashBuiltin*,
// }(user: felt) -> (res: felt) {
// }

// func write{
//     syscall_ptr: felt*,
//     range_check_ptr,
//     pedersen_ptr: HashBuiltin*,
// }(user: felt, value: felt) {
// }


// implicit argument:
// pedersen_ptr allows to compute the Pedersen hash function, range_check_ptr allows to compare integers. 
// the reason is that storage variables require these implicit arguments in order to compute the actual memory address of this variable.
// this may not be needed in simple variables such as balance, but with maps (see Storage maps) computing the Pedersen hash is part of what read() and write() do.
// syscall_ptr is a new primitive, unique to StarkNet contracts (it doesn’t exist in Cairo). 
// it allows the code to invoke system calls. It is also an implicit argument of read() and write() (required, in this case, because storage access is done using system calls).
// Increases the balance of the user by the given amount.
@external
func increase_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(amount: felt) {
    // Verify that the amount is positive.
    with_attr error_message(
            "Amount must be positive. Got: {amount}.") {
        assert_nn(amount);
    }

    // Obtain the address of the account contract.
    let (user) = get_caller_address();

    // Read and update its balance.
    let (res) = balance.read(user=user);
    balance.write(user, res + amount);
    return ();
}

// Returns the balance of the given user.
@view
func get_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(user: felt) -> (res: felt) {
    let (res) = balance.read(user=user);
    return (res=res);
}