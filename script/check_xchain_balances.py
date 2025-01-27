from web3 import Web3

# Connect to the blockchain
RPC_URL_L1 = "http://127.0.0.1:32002" # Replace with your RPC URL
web3_l1 = Web3(Web3.HTTPProvider(RPC_URL_L1))
RPC_URL_A = "http://127.0.0.1:32005"  # Replace with your RPC URL
web3_l2a = Web3(Web3.HTTPProvider(RPC_URL_A))
RPC_URL_B = "http://127.0.0.1:32006"  # Replace with your RPC URL
web3_l2b = Web3(Web3.HTTPProvider(RPC_URL_B))

def simulate_blockchain_call(contract_address, abi, function_name, *args):

    # Load the contract
    contract = web3_l1.eth.contract(address=web3_l1.to_checksum_address(contract_address), abi=abi)
    contract_a = web3_l2a.eth.contract(address=web3_l2a.to_checksum_address(contract_address), abi=abi)
    contract_b = web3_l2b.eth.contract(address=web3_l2b.to_checksum_address(contract_address), abi=abi)

    # Get the contract function
    contract_function = getattr(contract.functions, function_name)(*args)
    contract_a_function = getattr(contract_a.functions, function_name)(*args)
    contract_b_function = getattr(contract_b.functions, function_name)(*args)

    # Simulate the call
    try:
        response = contract_function.call()
        print(f"Blockchain call successful. Response, from L1 : {response}")
    except Exception as e:
        print(f"Error during blockchain call: {e}")

    try:
        response = contract_a_function.call()
        print(f"Blockchain call successful. Response, from L2A: {response}")
    except Exception as e:
        print(f"Error during blockchain call: {e}")

    try:
        response = contract_b_function.call()
        print(f"Blockchain call successful. Response, from L2B: {response}")
    except Exception as e:
        print(f"Error during blockchain call: {e}")

if __name__ == "__main__":
    # a simple ERC20
    #example_contract_address = "0x534cf76b8d56ab71cac1c211c9b38c81ca8e4b45"  # TAIKO
    example_contract_address = "0xA12297e9F5B9E9Ca7A810725904aFAf13a1eD568"  # SLOTH

    example_abi = [
        {
            "inputs": [],
            "name": "name",
            "outputs": [
                {
                    "internalType": "string",
                    "name": "",
                    "type": "string"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [],
            "name": "symbol",
            "outputs": [
                {
                    "internalType": "string",
                    "name": "",
                    "type": "string"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": True,
            "inputs": [
                {"name": "", "type": "address"}
            ],
            "name": "balanceOf",
            "outputs": [
                {"name": "", "type": "uint256"}
            ],
            "payable": False,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": True,
            "inputs": [
                {"name": "", "type": "address"},
                {"name": "", "type": "address"},
            ],
            "name": "allowance",
            "outputs": [
                {"name": "", "type": "uint256"}
            ],
            "payable": False,
            "stateMutability": "view",
            "type": "function"
        }
    ]

    # Simulate the blockchain call
    print("Swapper:")
    simulate_blockchain_call(example_contract_address, example_abi, "balanceOf", "0x614561D2d143621E126e87831AEF287678B442b8")
    print("Pool:")
    simulate_blockchain_call(example_contract_address, example_abi, "balanceOf", "0x97F7e77f1BdD8bd3f0BC8e7D85F9675750bA4732")
    print("Portal:")
    simulate_blockchain_call(example_contract_address, example_abi, "balanceOf", "0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E")

    print("")
    print("#allowance:")
    print("")

    print("Swapper:")
    simulate_blockchain_call(example_contract_address, example_abi, "allowance", "0x614561D2d143621E126e87831AEF287678B442b8", "0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E")
    print("Pool:")
    simulate_blockchain_call(example_contract_address, example_abi, "allowance", "0x97F7e77f1BdD8bd3f0BC8e7D85F9675750bA4732", "0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E")
    print("Portal:")
    simulate_blockchain_call(example_contract_address, example_abi, "allowance", "0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E", "0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E")