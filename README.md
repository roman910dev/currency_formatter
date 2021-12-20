# currency_formatter

A package to easily format money.

## Getting Started

To set how a `double` will be formatted, create a `CurrencyFormatterSettings`:

```dart
CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
  symbol:'€',
  symbolSide: SymbolSide.left,
  thousandSeparator: '.',
  decimalSeparator: ',',
);
```

`symbolSide` can be set to `SymbolSide.left`, `SymbolSide.right`, or `SymbolSide.none`.
`thousandSeparator` and `decimalSeparator` default to `'.'`, `','` or `','`,`'.'` automatically
depending on `symbolSide`.


To format a `num`,  `CurrencyFormatter.format()` is used:

```dart
CurrencyFormatter cf = CurrencyFormatter();
num amount = 1910.9347;
String formatted = cf.format(amount, euroSettings); // 1.910,93 €
String compact = cf.format(amount, euroSettings, compact: true); // 1,91K €
String threeDecimal = cf.format(amount, euroSettings, decimal: 3); // 1.910,945 €
```

Predefined settings for many currencies are also included in this package.
They are listed in the `CurrencyFormatter.majors` variable and their symbols in 
`CurrencyFormatter.majorSymbols`. They can be used in both of the following ways
which do exactly the same:

```dart
String inUSD = cf.format(amount, CurrencyFormatter.usd); // $ 1,910.93
String inRUB = cf.format(amount, cf.majors['rub']!); // 1.910,93 ₽

String jpySymbol = cf.majorSymbols['jpy']!; // ¥
```

In Flutter, you can get the default `CurrencyFormatterSettings ` according to the device
language using `cf.getLocal()`:

```dart
String inSystemCurrency = cf.format(amount, cf.getLocal() ?? cf.majors['usd']!);
```

You can get a `CurrencyFormatterSettings` from a currency symbol (if it is in
`CurrencyFormatter.majors`) with `CurrencyFormatter.getFromSymbol()`:

```dart
String fromSymbol = cf.format(amount, cf.getFromSymbol('£')!); // £ 1,910.35
```