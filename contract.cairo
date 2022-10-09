// Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

// Define a storage variable.
//the @storage_var decorator automatically create balance.read() and balance.write()
//initialized at zero
@storage_var
func balance() -> (res: felt) {
}

// implicit argument:
// pedersen_ptr allows to compute the Pedersen hash function, range_check_ptr allows to compare integers. 
// the reason is that storage variables require these implicit arguments in order to compute the actual memory address of this variable.
// this may not be needed in simple variables such as balance, but with maps (see Storage maps) computing the Pedersen hash is part of what read() and write() do.
// syscall_ptr is a new primitive, unique to StarkNet contracts (it doesn’t exist in Cairo). 
// it allows the code to invoke system calls. It is also an implicit argument of read() and write() (required, in this case, because storage access is done using system calls).
// Increases the balance by the given amount.
@external
func increase_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(amount: felt) {
    let (res) = balance.read();
    balance.write(res + amount);
    return ();
}

// Returns the current balance.
@view
func get_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (res: felt) {
    let (res) = balance.read();
    return (res=res);
}