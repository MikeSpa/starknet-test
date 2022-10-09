%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy

// Define a storage variable for the salt.
@storage_var
func salt() -> (value: felt) {
}

// Define a storage variable for the class hash of ownable_contract.
@storage_var
func ownable_class_hash() -> (value: felt) {
}

// An event emitted whenever deploy_ownable_contract() is called.
@event
func ownable_contract_deployed(contract_address: felt) {
}

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(ownable_class_hash_: felt) {
    ownable_class_hash.write(value=ownable_class_hash_);
    return ();
}

@external
func deploy_ownable_contract{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(owner_address: felt) {
    let (current_salt) = salt.read();
    let (class_hash) = ownable_class_hash.read();
    let (contract_address) = deploy(
        class_hash=class_hash,
        contract_address_salt=current_salt,
        constructor_calldata_size=1,
        constructor_calldata=cast(new (owner_address,), felt*),
        deploy_from_zero=FALSE,
    );
    salt.write(value=current_salt + 1);

    ownable_contract_deployed.emit(
        contract_address=contract_address
    );
    return ();
}