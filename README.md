## Zora Tests

The goal of this repository is primarily to test out Zora contracts so dApps can tap into the 
Zora ecosystem, without necessarily being in that system. The core idea is to have a 
[7579Module](https://eips.ethereum.org/EIPS/eip-7579#:~:text=id.-,Modules,-This) that users can 
install on their Smart Accounts and become holders of Creator Coins within Zora.

The intended use of this module capability is for use in dApps that generate some form of content
as a result of user activity on the dApp, primarily as a way to incentivise the user to either 
generate more activity within a dApp, or to suggest / enforce _good_ behaviour, or any other 
reason.

## Testing Plan

With the new Zora docs, things are a lot clearer and there is no need to reverse engineer the 
structure of the contracts and try to _hack_ it together. As such, the following testing categories
are designed / planned,

### Category 1: Sanity Check
> Confirm correct deployments, with hardcoded `poolConfig`


### Category 2: Using the SDK
> Pass in `poolConfig` value during fn call, or use Chainlink Functions


### Category 3: ERC7579
> Standardize the Zora Helper to a 7579Module

