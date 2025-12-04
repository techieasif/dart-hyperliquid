# Info API

The `InfoApi` allows you to retrieve public market data and account information without signing.

## Market Data

### Get L2 Book
Retrieve the Level 2 Order Book (bids and asks).

```dart
final book = await infoApi.getL2Book('BTC');
print('Best Bid: ${book.levels[0].px}');
```

### Get All Mids
Get the mid-prices for all active assets.

```dart
final mids = await infoApi.getAllMids();
print('ETH Price: ${mids['ETH']}');
```

### Get Meta
Fetch metadata about the exchange universe (asset IDs, decimals).

```dart
final meta = await infoApi.getMeta();
for (var asset in meta.universe) {
  print('${asset.name}: ID ${asset.szDecimals}');
}
```

## User Data

### Get User State
Retrieve detailed account information (balances, positions, leverage).

```dart
final state = await infoApi.getUserState('0x...');
print('Account Value: ${state.marginSummary.accountValue}');
for (var position in state.assetPositions) {
  print('Position: ${position.position.coin} ${position.position.szi}');
}
```

### Get Open Orders
Fetch all open orders for a user.

```dart
final orders = await infoApi.getOpenOrders('0x...');
for (var order in orders) {
  print('Order: ${order.coin} ${order.limitPx}');
}
```
