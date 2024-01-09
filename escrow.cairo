 use starknet::ContractAddress;


#[starknet::interface]
trait IEscrowContract<TContractState> {
    fn deposit_eth(ref self: TContractState, client_address: ContractAddress, amount: felt252, freelancer_address: ContractAddress);
    fn release_eth(ref self: TContractState, client_address: ContractAddress, freelancer_address: ContractAddress);
}

#[starknet::contract]
mod EscrowContract {
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        deposits: LegacyMap::<ContractAddress, (felt252, ContractAddress)>,
    }

    #[abi(embed_v0)]
    impl EscrowContract of super::IEscrowContract<ContractState> {
        fn deposit_eth(ref self: ContractState, client_address: ContractAddress, amount: felt252, freelancer_address: ContractAddress){
            // Logic to deposit ETH
            self.deposits.write(client_address, (amount, freelancer_address));
        }

        fn release_eth(ref self: ContractState, client_address: ContractAddress, freelancer_address: ContractAddress) {
            // Logic to release ETH
            let (amount, _ ): (felt252, ContractAddress) = self.deposits.read(client_address);
            //assert(freelancer_addr == 0, 'what');  // Ensure not already assigned
            self.deposits.write(client_address, (amount, freelancer_address));
            // Further logic for transferring funds and handling gas fees
        }
    }
}
