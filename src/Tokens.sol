// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract ERC20m is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
contract ERC721m is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}
    function mint(address to, uint256 tokenId, uint256 count) public {
        for (uint256 i = 0; i < count; i++) {
            _mint(to, tokenId + i);
        }
    }
}
// import "@openzeppelin/contracts/access/AccessControl.sol";

// define the minter role
/*
bytes32 constant MINTER_ROLE = keccak256("MINTER_ROLE");

contract Token is ERC20, AccessControl {
    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialOwner);
        _grantRole(MINTER_ROLE, initialOwner);
    }

    // Only the owner can mint new tokens
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
    // grant the minter role to an address
    function grantMinterRole(address to) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, to);
    }
}

contract NFT is ERC721, AccessControl {
    constructor(string memory name, string memory symbol, address initialOwner) ERC721(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialOwner);
        _grantRole(MINTER_ROLE, initialOwner);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    // Only the minter can mint new NFTs
    function mint(address to, uint256 tokenId, uint256 count) public onlyRole(MINTER_ROLE) {
        for (uint256 i = 0; i < count; i++) {
            _mint(to, tokenId + i);
        }
    }
    // grant the minter role to an address
    function grantMinterRole(address to) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, to);
    }
    
} */
