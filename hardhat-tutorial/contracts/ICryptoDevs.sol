//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10;
interface ICryptoDevs{
    function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint256 tokenId);
    function balanceOf(address owner) external view returns(uint256 balance);
}