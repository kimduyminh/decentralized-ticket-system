# Ticket Smart Contract

## Introduction

The `Ticket` smart contract is an ERC-721-based decentralized ticketing system designed to manage the creation, transfer, and sale of event tickets on the blockchain. This contract enables event organizers to mint unique tickets and users to securely purchase, transfer, or update ticket prices.

## Features

1. **NFT-based Ticket System**: Each ticket is a unique ERC-721 token.
2. **Event Organizer Management**: Add or remove trusted event organizers.
3. **Single and Bulk Ticket Minting**: Support for creating individual tickets or batches.
4. **Ticket Information Retrieval**: View detailed information about any ticket.
5. **Secure Ownership Transfers**: Only ticket owners can transfer their tickets.
6. **Price Management**: Update ticket prices with restrictions to prevent abuse.
7. **Decentralized Ticket Sales**: Facilitate secure ticket purchases with Ether.

## Contract Summary

### Inherited Contracts
- **ERC721**: Implements the NFT standard for tickets.
- **Ownable**: Restricts administrative functions to the contract owner.

---

### Key Components

#### 1. Ticket Structure
Each ticket includes the following:
- **Ticket Name** (`ticketName`): The name of the event.
- **Seat Position** (`seatPosition`): A unique identifier for the seat.
- **Price** (`price`): Ticket price in Ether.
- **Position Type** (`positionType`): Category of the ticket (e.g., VIP, Regular).

#### 2. Organizer Management
- **Add Organizer**: `_addEventOrganizer(address _address)` (Only owner).
- **Remove Organizer**: `_removeEventOrganizer(address _address)` (Only owner).

#### 3. Ticket Minting
- `_createTickets`: Create a single ticket for an event.
- `_createMultipleTickets`: Mint multiple tickets in bulk.

#### 4. Ticket Transfers
- `_transferTicket`: Transfer ticket ownership securely between addresses.

#### 5. Price Updates
- `_changeTicketPrice`: Update ticket prices, ensuring a minimum fee and valid conditions.

#### 6. Ticket Purchase
- `_purchaseTicket`: Securely buy tickets using Ether.

---

## Usage Guide

### Deployment
The contract requires:
- Solidity version: `^0.8.27`.
- Dependencies:
  - OpenZeppelin's ERC721 and Ownable contracts.

### Functions

#### Public/External
1. **Mint Tickets**:
   - `_createTickets` for single tickets.
   - `_createMultipleTickets` for batches.

2. **Manage Organizers**:
   - Add or remove organizers with `_addEventOrganizer` or `_removeEventOrganizer`.

3. **Update Prices**:
   - `_changeTicketPrice` to update the ticket price.

4. **View Tickets**:
   - `_ticketInfo` to get detailed ticket information.

5. **Transfer Tickets**:
   - `_transferTicket` to move ownership between addresses.

6. **Purchase Tickets**:
   - `_purchaseTicket` to buy tickets directly.

---

## Security Considerations

1. **Role-based Access Control**: Only authorized organizers can mint tickets.
2. **Ownership Validation**: Transfers and price updates require the ticket owner to authenticate.
3. **Immutable Data**: Tickets are securely linked to their owners via ERC-721.

---

## Upcoming Features

1. **Event Metadata**: Enhance tickets with IPFS or on-chain metadata.
2. **Secondary Market**: Introduce features for reselling tickets.
3. **Dynamic Pricing**: Enable adjustable pricing based on demand.

---

## License

This contract is licensed under the **MIT License**. See the `LICENSE` file for details.
