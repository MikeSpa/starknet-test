from starkware.starknet.public.abi import get_storage_var_address

user = 0x000BF956AA76FA0D30BAC1C0FAB5ADC4E975EC1F78354C880B95E5F2E93FD901
user_balance_key = get_storage_var_address("balance", user)
print(f"Storage key for user {user}:\n{user_balance_key}")
