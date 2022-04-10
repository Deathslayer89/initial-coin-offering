//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20,Ownable{
    uint256 public constant tokenPrice=0.001 ether;
    uint256 public constant tokenPerNFT=10* 10**18;
    uint256 public constant maxTotalSupply=1000* 10**18;
    ICryptoDevs CryptoDevsNFT;
    mapping(uint256=>bool) public tokenIdsClaimed;
    constructor(address _cryptoDevsContract) ERC20("Crypto Dev TOken","CD"){
        CryptoDevsNFT=ICryptoDevs(_cryptoDevsContract);
    }
    function mint(uint256 amount) public payable{
        uint256 _requiredAmount=tokenPrice*amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");
          // total tokens + amount <= 10000, otherwise revert the transaction
          uint256 amountWithDecimals = amount * 10**18;
          require(
              (totalSupply() + amountWithDecimals) <= maxTotalSupply,
              "Exceeds the max total supply available."
          );
          // call the internal function from Openzeppelin's ERC20 contract
          _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender=msg.sender;
        uint256 balance=CryptoDevsNFT.balanceOf(sender);
        require(balance>0, "No tokens to claim");
        uint256 amount=0;
        for(uint256 i=0;i<balance;i++){
            uint256 tokenId=CryptoDevsNFT.tokenOfOwnerByIndex(sender,i);
            if(tokenIdsClaimed[tokenId]==false){
                amount++;
                tokenIdsClaimed[tokenId]=true;
            }
        }
        require(amount>0, "No tokens to claim");
        _mint(msg.sender, amount*tokenPerNFT);
    }
    receive() external payable{
        
    }
    fallback() external payable{
        
    }
}
