# Zora Tests

The goal of this repository is primarily to test out Zora contracts so dApps can tap into the 
Zora ecosystem, without necessarily being in that system. The core idea is to have a 
[7579Module](https://eips.ethereum.org/EIPS/eip-7579#:~:text=id.-,Modules,-This) that users can 
install on their Smart Accounts and become holders of Creator Coins within Zora.

The intended use of this module capability is for use in dApps that generate some form of content
as a result of user activity on the dApp, primarily as a way to incentivise the user to either 
generate more activity within a dApp, or to suggest / enforce _good_ behaviour, or any other 
reason. See [example uses](#use-cases) below for inspiration.

## Testing Plan

With the new Zora docs, things are a lot clearer and there is no need to reverse engineer the 
structure of the contracts and try to _hack_ it together. As such, the following testing categories
are designed / planned,

### Category 1: Sanity Check
> Confirm correct deployments, with hardcoded `poolConfig`

This category is a simple use case, with the pattern being a contract representing the user and 
an admin contract that triggers the calls to Zora Factory. Note that there is no smart account 
functionality in this category / pattern.

Final thing to note is that the admin contract calls callbacks within the user contract. This is 
because the Zora indexer considers `msg.sender` to be the creator of any Coin, and we want the user
to be the final creator of the Coin.

#### 1a: Static `poolConfig`
> Hardcoded and static configuration, based on [reference txns](./notes/reference_txns.md)

Content Coin goes through correctly, but Creator Coin does not show up as expected. See more in 
[initial notes](./notes/category-1a-20250822.md).


#### 1b: Dynamic `poolConfig`
> Still generated within contract, but now as updateable contract variables


#### 1c: Generate `uri`
> Passing in non-ipfs uris to Zora Factory


### Category 2: Using the SDK
> Pass in `poolConfig` value during fn call, or use Chainlink Functions


### Category 3: ERC7579
> Standardize the Zora Helper to a 7579Module


## Use Cases

### Token Tuner

This is a daily DeFi game where the users are challenged to trade strategically and follow a 
predefined curve. The user who sticks closest to the curve, over the course of the day, will win 
the opportunity to determine the following day's curve. As such, this curve selection and 
subsequent trading activity is considered to be a sort of social art, where the initial conditions 
(ie, the curve parameters) are quite important. Therefore, we do not want a winning user to put in 
"bad" parameters, and instead focus on something that may look good at the end. This is where Zora
comes in.

Yes, winners can, and likely will, be awarded NFTs of their creations as well, but what Zora 
enables is the following,
- A more granular market, as compared to a NFT.
- Network effects, in that non-users of Token Tuners may purchase some of this Content.
- Finally, exposure to the dApp in general. As this is a daily game, there will be a Coin created 
daily, awarded to some user. However, each Coin will look and feel very similar, hopefully causing 
curiosity around the dApp.

In the end, what Zora enables is another layer of incentive for the users to define "good" curves
so they may fetch some tokens on the secondary market of Zora.

### Semicolon Fingers