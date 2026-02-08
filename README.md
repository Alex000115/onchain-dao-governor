# On-Chain DAO Governor

This repository features a simplified version of the Governor protocol. It enables a decentralized community to manage a treasury or update smart contract parameters through transparent, on-chain voting.

### Core Components
* **Proposal Lifecycle:** Proposals move from `Pending` to `Active`, `Succeeded`, and finally `Executed`.
* **Quorum & Threshold:** Configurable requirements to ensure only broad community consensus leads to changes.
* **Timelock Integration:** Built-in delay between a successful vote and execution to allow users to exit if they disagree with the outcome.

### Governance Workflow
1. **Propose:** A token holder with enough voting power submits a transaction.
2. **Vote:** Holders cast votes during the voting period.
3. **Queue:** If passed, the proposal enters a Timelock.
4. **Execute:** After the delay, the transaction is performed by the DAO.
