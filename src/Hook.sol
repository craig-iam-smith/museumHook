// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";

import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "v4-core/src/types/PoolId.sol";
import {BalanceDelta} from "v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/src/types/BeforeSwapDelta.sol";
// import erc20 interface from openzeppelin
// import erc721 interface from openzeppelin
import {IERC20m} from "./IERC20m.sol";
import {IERC721m} from "./IERC721m.sol";

import {console} from "forge-std/console.sol";

contract mHook is BaseHook {
    using PoolIdLibrary for PoolKey;

    // NOTE: ---------------------------------------------------------
    // state variables should typically be unique to a pool
    // a single hook contract should be able to service multiple pools
    // ---------------------------------------------------------------
    mapping(address => uint256) public totalPurchases;

    IERC20m public rewardToken;
    IERC20m public yieldToken;
    IERC721m public rewardNFT;
    uint256 public rewardRate = 100;
    uint256 public nftRate = 1e18;

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

    function beforeSwap(address user, PoolKey calldata key, IPoolManager.SwapParams calldata swapParams, bytes calldata )
        external
        override
        returns (bytes4, BeforeSwapDelta, uint24)
    {
        // keeping track of the number of times the hook is called
        beforeSwapCount[key.toId()]++;
        // verify that this is a purchase of the token with Eth
        // if (!key.currency0.isAddressZero()) return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
        // if (!swapParams.zeroForOne) return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);

        return (BaseHook.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    function afterSwap(address user, PoolKey calldata key, IPoolManager.SwapParams calldata swapParams, BalanceDelta delta, bytes calldata hookData)
        external
        override
        returns (bytes4, int128)
    {
        uint256 rewardAmount;
        // verify that this is a purchase of the token with Eth
        // if (!key.currency0.isAddressZero()) return (BaseHook.beforeSwap.selector, 0);
        // if (!swapParams.zeroForOne) return (BaseHook.beforeSwap.selector, 0);

// @dev todo- decode the hook data to get the sponsor and NFT id
    //    (address sponsor, uint256 nftId) = abi.decode(hookData, (address, uint256));
        uint256 nftId = getNFTId(user);
        afterSwapCount[key.toId()]++;
 
        // get the amount Eth
        uint256 ethSpendAmount = swapParams.amountSpecified < 0 
            ? uint256(-swapParams.amountSpecified) 
            : uint256(int256(-delta.amount0()));
        // compute the reward amount
        rewardAmount = ethSpendAmount * rewardRate / 100;
        // get the number of NFTs to mint (number of Eth spent) 
        uint256 nftCount = ethSpendAmount / nftRate;
        
        // temporary manual setting of rewards
        rewardAmount = 1;
        nftCount = 1;
        console.log("user: %s", user);
        mintRewardTokens(user, rewardAmount);
        mintNFT(user, nftId, nftCount);
//        mintYieldTokens(sponsor, ethSpendAmount);

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
                mintRewardTokens(user, 1);
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

    function mintYieldTokens(address user, uint256 amount) internal {
        // mint the yield tokens to the user who provided liquidity
        // this is a placeholder for the actual implementation
        yieldToken.mint(user, amount);
    }
    function getNFTId(address user) internal view returns (uint256) {
        // @dev - provide callout to get the NFT id
        return 1;
    }
    function mintRewardTokens(address user, uint256 conversionRate) internal {
        // mint the reward tokens to the user
        // this is a placeholder for the actual implementation
        rewardToken.mint(user, conversionRate);
        console.log("minting reward tokens to user", user);
        console.log("token", address(rewardToken));
    }
    function mintNFT(address user, uint256 nftId, uint256 nftCount) internal {
        // mint the NFT to the user
        // this is a placeholder for the actual implementation
        rewardNFT.mint(user, nftId, nftCount);
    }
    function setRewardAddresses(address _rewardToken, address _rewardNFT, address _yieldToken) public {
        rewardToken = IERC20m(_rewardToken);
        rewardNFT = IERC721m(_rewardNFT);
        yieldToken = IERC20m(_yieldToken);
    }
}
