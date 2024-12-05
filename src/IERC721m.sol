// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
//import {IAccessControl} from "@openzeppelin/contracts/interfaces/IAccessControl.sol";

interface IERC721m is IERC721 {
    function mint(address to, uint256 tokenId, uint256 count) external;
}
