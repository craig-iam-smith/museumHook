# museumHook

The real world problem we are solving is tokenizing non-traditional real world assets to support public goods.  Our scenario is museums with low attendance that are having trouble meeting their expenses. The museums have assets (displays) that have verifiable value but no way to leverage the value of the asset other than charging to view it.  Let’s unlock the value of their real world assets (RWAs) by tokenizing, and using the value to generate income by using a revenue generating protocol like Aave.

Let’s use a car museum for our example. (Side note: there are many legal issues, we are ignoring all of them for now)

Offering part of an individual car for sale would cause logistical confusion and valuation risk because of a unique vehicle. We can take tokens of the RWAs, deposit them in to a contract (let’s call it a garage) and issue ERC20 tokens backed by the group of RWAs.  This gives us a fungible token, that is completely liquid, backed by a garage that contains cars that all have a verifiable appraised value. We will have an oracle that keeps track of the value each car and the total value. ( The appraisal process and updating is a legal issue )  

We now have a fungible token, backed by rising value assets that can then be sold and the museum can take the proceeds to a protocol to produce sustainable income.   

Uniswap is the platform to sell these tokens, providing single sided liquidity to a Uniswap pool is great to handle the sale of fungible tokens, but to generate interest we need to offer more than just an asset backed token.  This is where the Uniswap V4 hook comes in. Just having an asset backed token is not enough to sell quickly, we need the idea of supporting a museum and rewards to get people involved.  Offering both NFTs and ERC20 $MERCH tokens to purchase tickets or merchandise at the gift shop are great rewards.  

The app for the museum can allow the user to specify their rewards.  

The hook will mint rewards to purchaser based on the provided hook data (which NFT, rate of dispensing $MERCH tokens based on purchase size)  Our afterSwap hook mints erc20 and erc721 tokens based on inputs from hook data








# v4-template
### **A template for writing Uniswap v4 Hooks 🦄**

[`Use this Template`](https://github.com/uniswapfoundation/v4-template/generate)

1. The example hook [Hook.sol](src/Hook.sol) demonstrates the `beforeSwap()` and `afterSwap()` hooks
2. The test template [Hook.t.sol](test/Hook.t.sol) preconfigures the v4 pool manager, test tokens, and test liquidity.

<details>
<summary>Updating to v4-template:latest</summary>

This template is actively maintained -- you can update the v4 dependencies, scripts, and helpers: 
```bash
git remote add template https://github.com/uniswapfoundation/v4-template
git fetch template
git merge template/main <BRANCH> --allow-unrelated-histories
```

</details>

---

### Check Forge Installation
*Ensure that you have correctly installed Foundry (Forge) and that it's up to date. You can update Foundry by running:*

```
foundryup
```

## Set up

*requires [foundry](https://book.getfoundry.sh)*

```
forge install
forge test --via-ir
```

### Local Development (Anvil)

Other than writing unit tests (recommended!), you can only deploy & test hooks on [anvil](https://book.getfoundry.sh/anvil/)

```bash
# start anvil, a local EVM chain
anvil

# in a new terminal
forge script script/Anvil.s.sol \
    --rpc-url http://localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --broadcast
```

See [script/](script/) for hook deployment, pool creation, liquidity provision, and swapping.

---

<details>
<summary><h2>Troubleshooting</h2></summary>



### *Permission Denied*

When installing dependencies with `forge install`, Github may throw a `Permission Denied` error

Typically caused by missing Github SSH keys, and can be resolved by following the steps [here](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh) 

Or [adding the keys to your ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent), if you have already uploaded SSH keys

### Hook deployment failures

Hook deployment failures are caused by incorrect flags or incorrect salt mining

1. Verify the flags are in agreement:
    * `getHookCalls()` returns the correct flags
    * `flags` provided to `HookMiner.find(...)`
2. Verify salt mining is correct:
    * In **forge test**: the *deployer* for: `new Hook{salt: salt}(...)` and `HookMiner.find(deployer, ...)` are the same. This will be `address(this)`. If using `vm.prank`, the deployer will be the pranking address
    * In **forge script**: the deployer must be the CREATE2 Proxy: `0x4e59b44847b379578588920cA78FbF26c0B4956C`
        * If anvil does not have the CREATE2 deployer, your foundry may be out of date. You can update it with `foundryup`

</details>

---

Additional resources:

[Uniswap v4 docs](https://docs.uniswap.org/contracts/v4/overview)

[v4-periphery](https://github.com/uniswap/v4-periphery) contains advanced hook implementations that serve as a great reference

[v4-core](https://github.com/uniswap/v4-core)

[v4-by-example](https://v4-by-example.org)

