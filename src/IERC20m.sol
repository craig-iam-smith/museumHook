// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
//import {IAccessControl} from "@openzeppelin/contracts/interfaces/IAccessControl.sol";

interface IERC20m is IERC20 {
    function mint(address to, uint256 amount) external;
}
