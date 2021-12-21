// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract RandomMachine{

    address private owner;
    uint public randomSeed;

    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
        // modifier to check if caller is owner
    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    constructor(){
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    function changeSeed(uint _randomSeed) external{
        require(msg.sender == owner);
        randomSeed = _randomSeed;
    }
}
contract DiceGame {

    address private owner;
    uint256 nonce;
    RandomMachine randomMachine; // for feeding external seed outside blockchain
    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    /**
     * @dev Set contract deployer as owner
     */
    constructor(address randomMachineAddress) {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);

        // init external randomMachine
        randomMachine = RandomMachine(randomMachineAddress);
        nonce = 0;
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }

    function getNonce() external view isOwner returns (uint){
        return nonce;
    } 

    function getRandomNumber(uint max) external returns (uint){
        uint randomNumber = uint(
            keccak256(
                abi.encodePacked(
                    block.difficulty,
                    msg.sender,
                    nonce,
                    randomMachine.randomSeed()
                )
            )
        ) % max + 1;
        nonce ++;
        if(nonce > 1000000){
            nonce = 0;
        }
        return randomNumber;
    }

}