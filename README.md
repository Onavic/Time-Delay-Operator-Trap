
# Time-Delay Operator Trap

**A Drosera-compatible trap that monitors operator activity and triggers a responder if operators act too soon.**

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Contracts](#contracts)
5. [Installation](#installation)
6. [Deployment](#deployment)
7. [Configuration](#configuration)
8. [Usage](#usage)
9. [Testing](#testing)
10. [License](#license)

---

## Overview

The **Time-Delay Operator Trap** is a smart contract system designed to track operator actions and enforce a minimum waiting period (in blocks) between actions. If an operator acts before the required delay, the trap triggers and calls a responder contract to handle the alert.

This project is fully integrated with **Drosera**, allowing automated monitoring and reaction on-chain.

---

## Features

* Track the last action of each operator.
* Configurable block delay to define how long operators must wait.
* Automatic triggering of a responder contract when trap conditions are met.
* Whitelist support for private traps.
* Full Drosera integration for on-chain monitoring.

---

## Architecture

```
┌────────────┐      ┌───────────────┐      ┌───────────────┐
│ ActionLog  │ ---> │ TimeDelayTrap │ ---> │ Responder     │
└────────────┘      └───────────────┘      └───────────────┘
```

* **ActionLog:** Stores last action block and action hash for each operator.
* **TimeDelayOperatorTrap:** Monitors operators and decides if the trap should trigger.
* **TimeDelayOperatorResponder:** Reacts to the trap alert by executing a response function.

---

## Contracts

1. **ActionLog.sol**
   Stores operator activity and hashes.

2. **TimeDelayOperatorTrap.sol**
   Core trap logic. Checks whether an operator has acted too soon.

3. **TimeDelayOperatorResponder.sol**
   Responds to the trap when triggered. Drosera calls `respond(address)` on trigger.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/your-repo/time-delay-operator-trap.git
cd time-delay-operator-trap
```

Install dependencies:

```bash
forge install
```

---

## Deployment

1. Create a `.env` file with your private key and RPC URL:

```env
PRIVATE_KEY="0xYOUR_PRIVATE_KEY"
RPC_URL="https://your-rpc-url"
```

2. Deploy contracts using Forge:

```bash
forge script script/DeployTimeDelayTrap.s.sol:DeployTimeDelayTrap \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --broadcast
```

✅ This will deploy:

* `ActionLog`
* `TimeDelayOperatorTrap`
* `TimeDelayOperatorResponder`

Logs will show the deployed addresses for each contract.

---

## Configuration

Create or update `drosera.toml`:

```toml
[traps.time_delay_operator]
path = "out/TimeDelayOperatorTrap.sol/TimeDelayOperatorTrap.json"
response_contract = "0xDeployedResponderAddress"
response_function = "respond(address)"
block_sample_size = 5
cooldown_period_blocks = 0
private_trap = true
whitelist = ["0xYourOperatorAddress"]
```

---

## Usage

### Record Operator Action

```solidity
trap.recordAction(operatorAddress);
```

### Check if Trap is Triggered

```solidity
bool triggered = trap.shouldRespond(operatorAddress);
```

### Respond via Responder

```solidity
responder.respond(operatorAddress);
```

* Drosera will automatically call the responder when the trap triggers.

---

## Testing

Run unit tests:

```bash
forge test
```

Tests included:

* `testTrapTriggersIfOperatorActsTooSoon()`
* `testTrapDoesNotTriggerIfOperatorWaitedEnough()`

All tests pass on Forge with Solidity 0.8.20.

---

## License

MIT License – see `LICENSE` file.

---