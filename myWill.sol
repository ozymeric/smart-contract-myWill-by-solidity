// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.7.0 <0.9.0;

// We'll create a contract which will keep the fortune of a person.
// He will determine family members and an amount dedicated to theese members
// to inherit his fortune.
// And when he is deceased, this smart contract will distribute his fortune
// to the family members he predetermined and make the payments according
// to the amounts he predetermined. 

contract MyWill{

    address public owner;
    uint public myFortune;
    bool public isDeceased;

    constructor() payable {
        owner = msg.sender; // this sets the one who deploys the contracts as the owner of this contract.
        myFortune = msg.value; // this sets the predetermined contract value as the fortune.
        isDeceased = false; // the contract won't be executable until this variable turns into "true".       
    }

    // a modifier to be sure 
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier mustBeDeceased {
        require(isDeceased == true);
        _;
    }

    // the owner will determine family members and put their wallet addresses into this
    // famlilyWallets lists.
    address payable [] public familyWallets;

    // the owner will determine the amount he will give from his fortune by this
    // mapping. Like, this address will take this amount.
    // so when we type an address to inheritance variable we'll get the amount 
    // this address deserves from the fortune.
    mapping(address => uint) public inheritance;

    // the owner will set a certain amount to the desired family member addresses.
    // the amount will be in "wei" so don't forget to add 18 zeroes to the end of the
    // number we type !!!!!!!!!!!!!! 
    function setInheritance(address payable wallet, uint amount) public {
        // this if statement checks whether the amount which is being tries to dedicated
        // to a member is present in the fortune or not. 
        // if the desired amount is more than the fortune or the remaining fortune
        // this if statament won't let this execution work!!!
        if (amount <= myFortune) {
            familyWallets.push(wallet);
            inheritance[wallet] = amount;
        }
        myFortune -= amount; // everytime the owner decides an amount, this amount 
        // will be subtracted from the fortune amount so that he won't be able to
        // distribute more than he actually have. 
    }

    // now we create a function to execute the distribution of the fortune to the
    // related family members by the related amounts. 
    // and we'll use the mustBeDeceased modifier to check if the owner is deceased or not.
    // if he is not deceased this function won't work!
    function payout() public mustBeDeceased{
        for(uint i=0; i<familyWallets.length; i++){
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }   // this for loop will iterate through all the family addresses and
            // pay them their dedicated amount of ether.
            // we do this payments by the help of ".transfer()" method.

          // familyWallets[i] is an address.
          // inheritance[familyWallets[i]] is a uint amount. 
          // this line means: to the address which is familyWallets[i];
          // transfer(this amount)... which is:
          // inheritance is a mapping which contains an address and an amount
          // dedicated to that address so:
          // inheritance[familyWallets[i]] is an amount. 
          // the amount dedicated to the familyWallets[i] address.  
    }

    function setDeceased() public onlyOwner {
        isDeceased = true;
        payout();
    } //This function will automatically call and execute the payout function 
    // by the time
    // setDeceased function is called by firstly changing
    // "isDeceased" variable to "true".
    // So when the owner executes setDeceased functions, he weill automatically set
    // the isDeceased variable to "true" and distribute the fortune among the family
    // according to the predetermined amounts. 

}