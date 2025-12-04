# Exchange API

The `ExchangeApi` handles authenticated actions like placing orders, updating leverage, and transfers. All actions require a `Credentials` object (e.g., `EthPrivateKey`).

## Trading

### Place Order
Place a limit or market order.

```dart
final result = await exchangeApi.placeOrder(
  coin: 'BTC',
  isBuy: true,
  sz: 0.01,
  limitPx: 30000.0,
  orderType: {'limit': {'tif': 'Gtc'}},
  reduceOnly: false,
);
```

### Cancel Order
Cancel an open order by its ID.

```dart
final result = await exchangeApi.cancelOrder(
  coin: 'BTC',
  orderId: 123456789,
);
```

### Update Leverage
Set the leverage mode (Cross/Isolated) and value for an asset.

```dart
// Set 10x Cross Leverage
await exchangeApi.updateLeverage('BTC', true, 10.0);

// Set 5x Isolated Leverage
await exchangeApi.updateLeverage('ETH', false, 5.0);
```

## Transfers & Withdrawals

### USD Send
Send USDC to another Hyperliquid account (L2 transfer).

```dart
await exchangeApi.usdSend('0xRecipientAddress...', 100.0);
```

### Withdraw
Withdraw USDC to the Arbitrum L1 chain.

```dart
await exchangeApi.withdraw3('0xL1Address...', 500.0);
```

### Spot Send
Send a Spot asset (e.g., PURR) to another account.

```dart
await exchangeApi.spotSend('0xRecipient...', 'PURR:0xTokenAddress...', 10.0);
```

## Sub-Accounts

### Create Sub-Account
Create a new sub-account managed by your main wallet.

```dart
await exchangeApi.createSubAccount('TradingBot1');
```

### Sub-Account Transfer
Transfer funds between main account and sub-account.

```dart
// Deposit 1000 USD to sub-account
await exchangeApi.subAccountTransfer('0xSubAccount...', true, 1000.0);
```
