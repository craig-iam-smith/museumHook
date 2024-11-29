// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";

import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "v4-core/src/types/PoolId.sol";
import {BalanceDelta} from "v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/src/types/BeforeSwapDelta.sol";

contract mHook is BaseHook {
    using PoolIdLibrary for PoolKey;

    // NOTE: ---------------------------------------------------------
    // state variables should typically be unique to a pool
    // a single hook contract should be able to service multiple pools
    // ---------------------------------------------------------------

    mapping(PoolId => uint256 count) public beforeSwapCount;
    mapping(PoolId => uint256 count) public afterSwapCount;

    mapping(PoolId => uint256 count) public beforeAddLiquidityCount;
    mapping(PoolId => uint256 count) public beforeRemoveLiquidityCount;
    mapping(PoolId => mapping(address => uint256)) public myAge;

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: true,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: true,
            afterRemoveLiquidity: false,
            beforeSwap: true,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    // -----------------------------------------------
    // NOTE: see IHooks.sol for function documentation
    // -----------------------------------------------

    function beforeSwap(address user, PoolKey calldata key, IPoolManager.SwapParams calldata, bytes calldata )
        external
        override
        returns (bytes4, BeforeSwapDelta, uint24)
    {
        // keeping track of the number of times the hook is called
        beforeSwapCount[key.toId()]++;

        // get the conversion rate of ERC20 reward tokens to the purchase token
        // this is a placeholder for the actual implementation
        uint256 conversionRate = 1;
        // mint the reward tokens to the user
        // this is a placeholder for the actual implementation
        mintRewardTokens(key, user, conversionRate);
        // get info about available NFTs to mint
        // this is a placeholder for the actual implementation
        uint256 nftId = 1;
        // get number of NFTs to mint
        // this is a placeholder for the actual implementation
        uint256 nftCount = 1;
        // mint the NFT to the user
        // this is a placeholder for the actual implementation
        
        mintNFT(key, user, nftId, nftCount);

        return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    function afterSwap(address user, PoolKey calldata key, IPoolManager.SwapParams calldata, BalanceDelta, bytes calldata hookData)
        external
        override
        returns (bytes4, int128)
    {
        afterSwapCount[key.toId()]++;
        return (BaseHook.afterSwap.selector, 0);
    }

    function beforeAddLiquidity(
        address user,
        PoolKey calldata key,
        IPoolManager.ModifyLiquidityParams calldata,
        bytes calldata
    ) external override returns (bytes4) {

        beforeAddLiquidityCount[key.toId()]++;
        // if liquidity adder is the not pool manager, mint the NFTs to the user
        if (user != address(poolManager)) {
            liquidityAge(key, user);
        }
        return BaseHook.beforeAddLiquidity.selector;
    }

    function beforeRemoveLiquidity(
        address user,
        PoolKey calldata key,
        IPoolManager.ModifyLiquidityParams calldata,
        bytes calldata
    ) external override returns (bytes4) {
        beforeRemoveLiquidityCount[key.toId()]++;
        // if liquidity remover is the not pool manager, burn the NFTs from the user
        // and the reward to
        if (user != address(poolManager)) {
            if (getAge(key, user) > 1000) {
                mintRewardTokens(key, user, 1);
            }
        }
        return BaseHook.beforeRemoveLiquidity.selector;
    }
    function liquidityAge(PoolKey memory key, address user) internal returns (uint256) {
        // set the liquidity age to the current block timestamp
        if (myAge[key.toId()][user] == 0) {
            myAge[key.toId()][user] = block.timestamp;
        }
    }

    function getAge(PoolKey memory key, address user) internal view returns (uint256) {
        return myAge[key.toId()][user];
    }
    function mintRewardTokens(PoolKey memory key, address user, uint256 conversionRate) internal {
        // mint the reward tokens to the user
        // this is a placeholder for the actual implementation
    }
    function mintNFT(PoolKey memory key, address user, uint256 nftId, uint256 nftCount) internal {
        // mint the NFT to the user
        // this is a placeholder for the actual implementation
    }
}
