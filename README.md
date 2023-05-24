# User Faker

Creates accounts for PoolTogether V5 vaults in batches.

### Deployed On:

- [Goerli](https://goerli.etherscan.io/address/0x4b1fb48851a2747c324a4f6f77c09ccdf4b15609)
- [Mumbai](https://mumbai.polygonscan.com/address/0xda33207b32075f9fb047ca3246bbeb6432fe3f91)
- [Sepolia](...)

## Usage

Call `setFakeUsers(vault, count, tokenFaucet)` where `count` is the desired number of fake users.

Note: gas limits account creation to about 50 per transaction. So to create 200 accounts, you'd need to run 4 transactions:

```
setFakeUsers(vault, 50, tokenFaucet)
setFakeUsers(vault, 100, tokenFaucet)
setFakeUsers(vault, 150, tokenFaucet)
setFakeUsers(vault, 200, tokenFaucet)
```

# Foundry template

Template to kickstart a Foundry project.

## Getting started

The easiest way to get started is by clicking the [Use this template](https://github.com/pooltogether/foundry-template/generate) button at the top right of this page.

If you prefer to go the CLI way:

```
forge init my-project --template https://github.com/pooltogether/foundry-template
```

## Development

### Installation

You may have to install the following tools to use this repository:

- [Foundry](https://github.com/foundry-rs/foundry) to compile and test contracts
- [direnv](https://direnv.net/) to handle environment variables
- [lcov](https://github.com/linux-test-project/lcov) to generate the code coverage report

Install dependencies:

```
npm i
```

### Env

Copy `.envrc.example` and write down the env variables needed to run this project.

```
cp .envrc.example .envrc
```

Once your env variables are setup, load them with:

```
direnv allow
```

### Compile

Run the following command to compile the contracts:

```
npm run compile
```

### Coverage

Forge is used for coverage, run it with:

```
npm run coverage
```

You can then consult the report by opening `coverage/index.html`:

```
open coverage/index.html
```

### Code quality

[Husky](https://typicode.github.io/husky/#/) is used to run [lint-staged](https://github.com/okonet/lint-staged) and tests when committing.

[Prettier](https://prettier.io) is used to format TypeScript and Solidity code. Use it by running:

```
npm run format
```

[Solhint](https://protofire.github.io/solhint/) is used to lint Solidity files. Run it with:

```
npm run hint
```

### CI

A default Github Actions workflow is setup to execute on push and pull request.

It will build the contracts and run the test coverage.

You can modify it here: [.github/workflows/coverage.yml](.github/workflows/coverage.yml)

For the coverage to work, you will need to setup the `MAINNET_RPC_URL` repository secret in the settings of your Github repository.
