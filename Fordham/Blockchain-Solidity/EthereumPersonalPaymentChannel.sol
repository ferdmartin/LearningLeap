// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract PaymentChannel {
 address payable constant mallory_address = payable(0xdD870fA1b7C4700F2BD7f44238821C26f7392148); // Mallory's address
 address payable constant bob_address = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4); // Bob's address
 
uint private constant y = 16; // Fixed y value for future hashing

mapping(address => uint256) public balances;
 
bytes32 private submittedHash;
uint private expiration;

constructor() {
    expiration = block.timestamp + 3 minutes; // Timeout for the channel to expire
    }
 
function deposit() public payable {
    require(block.timestamp < expiration, "Channel has expired.");
    require(msg.sender == mallory_address || msg.sender == bob_address, "Only Mallory or Bob can make deposits.");
    require(msg.value > 0, "Deposit must be more than 0");
    balances[msg.sender] += msg.value;
    }
 
function submit_secret_code(uint secret_code) public {
    require(block.timestamp < expiration, "Channel has expired.");
    require(msg.sender == mallory_address || msg.sender == bob_address, "Only Mallory or Bob can submit a hash.");

    submittedHash = keccak256(abi.encodePacked(secret_code, y)); // This is a secret code with the amount to be withdraw and our secret y
    }
 
function withdraw_bob(uint256 amount, uint secret_code) public {
    require(block.timestamp < expiration, "Channel has expired.");
    require(msg.sender == bob_address, "Only Bob can call this function.");

    bytes32 hash = keccak256(abi.encodePacked(secret_code, y)); //SHA3 secret code
    require(submittedHash == hash, "Invalid hash.");
    require(balances[mallory_address] >= amount, "Insufficient balance on Mallory's account.");

    balances[mallory_address] -= amount;
    balances[bob_address] += amount; 
    }
 
function withdraw_mallory(uint256 amount, uint secret_code) public {
    require(block.timestamp < expiration, "Channel has expired.");
    require(msg.sender == mallory_address, "Only Mallory can call this function.");
    
    bytes32 hash = keccak256(abi.encodePacked(secret_code, y)); //SHA3 secret code
    require(submittedHash == hash, "Invalid hash.");
    require(balances[bob_address] >= amount, "Insufficient balance on Bob's account.");
    balances[bob_address] -= amount;
    balances[mallory_address] += amount;
    }
 
function withdraw() public { // withdraw remaining balances
    require(block.timestamp >= expiration, "Channel has not expired yet. You need to wait for its expiration."); // Mallory or Bob can withdraw balance after expiration only
    payable(mallory_address).transfer(balances[mallory_address]);
    balances[mallory_address] = 0;
    payable(bob_address).transfer(balances[bob_address]);
    balances[bob_address] = 0;
    selfdestruct(payable(bob_address));
    }
