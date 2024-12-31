# RoyaltyVault

## Features

- Asset registration and management
- Automated royalty calculations and distributions
- Creator earnings tracking
- Owner-only administrative controls
- Fixed 5% royalty rate
- Safety checks and input validation

## Contract Functions

### Administrative Functions

- `register-asset`: Register new assets with their creators
- `deactivate-asset`: Disable royalty collection for specific assets

### Payment Functions

- `pay-royalty`: Process royalty payments for assets
- Minimum payment: 1,000,000 microSTX
- Automatic 5% royalty calculation

### Read-Only Functions

- `get-creator-stats`: View creator earnings and last payout
- `get-asset-info`: Get asset registration details
- `calculate-royalty`: Calculate royalty amount for a payment

## Security Features

- Asset ID validation
- Creator validation
- Owner-only access controls
- Duplicate asset prevention
- Active status checking

## Error Codes

- `100`: Unauthorized access
- `101`: Invalid payment amount
- `102`: Asset creator not found
- `103`: Inactive asset
- `104`: Invalid asset ID
- `105`: Invalid creator address

## Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/clarity-royalties-manager.git
```

2. Deploy using Clarinet:
```bash
clarinet contract deploy royalty-manager
```

## Testing

Run the test suite:
```bash
clarinet test
```