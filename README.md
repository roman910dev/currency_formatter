# currency_formatter

A package to easily format money. It supports setting a custom currency symbol and format,
using some of the inbuilt ones for the main currencies or using the system one.

## Format money

To set how a `double` will be formatted, create a `CurrencyFormat`:

```dart
CurrencyFormat euroSettings = CurrencyFormat(
  code: 'eur',
  symbol: '€',
  symbolSide: SymbolSide.left,
  thousandSeparator: '.',
  decimalSeparator: ',',
  symbolSeparator: ' ',
);
```

`symbolSide` can be set to `SymbolSide.left`, `SymbolSide.right`, or `SymbolSide.none`.
`thousandSeparator` and `decimalSeparator` default to `'.'`, `','` or `','`,`'.'` automatically
depending on `symbolSide`.

To format a `num`, `CurrencyFormatter.format()` is used:

```dart
num amount = 1910.9347;
String formatted = CurrencyFormatter.format(amount, euroSettings); // 1.910,93 €
String compact = CurrencyFormatter.format(amount, euroSettings, compact: true); // 1,91K €
String threeDecimal = CurrencyFormatter.format(amount, euroSettings, decimal: 3); // 1.910,945 €
```

## Parse formatted money

To get a `num` from a formatted `String`, use `CurrencyFormatter.parse()`:

```dart
// Above's example continuation
num parseFormatted = CurrencyFormatter.parse(formatted, euroSettings); // 1910.93
num parseCompact = CurrencyFormatter.parse(compact, euroSettings); // 1910.0
num parseThreeDecimal = CurrencyFormatter.parse(threeDecimal, euroSettings); // 1910.935
```

## Predefined `CurrencyFormat`s

Predefined settings for many currencies are also included in this package.
They are listed in the `CurrencyFormatter.majorsList` list and defined as static constants in the `CurrencyFormat` class.

```dart
String inUSD = CurrencyFormatter.format(amount, CurrencyFormat.usd); // $ 1,910.93
String inRUB = CurrencyFormatter.format(amount, CurrencyFormatter.fromCode('rub')!); // 1.910,93 ₽

String jpySymbol = CurrencyFormatter.jpy.symbol; // ¥
```

### Get local `CurrencyFormat`

In Flutter, you can get the default `CurrencyFormat` according to the device
language using `CurrencyFormat.local`:

```dart
String inSystemCurrency = CurrencyFormatter.format(amount, CurrencyFormat.local ?? CurrencyFormat.usd);
```

If instead you want to get the `CurrencyFormat` for a specific locale, use `CurrencyFormat.fromLocale()`:

```dart
String inLocaleCurrency = CurrencyFormatter.format(amount, CurrencyFormat.fromLocale('en_US')!);
```

### Get `CurrencyFormat` from symbol or code

You can get a `CurrencyFormat` from a currency symbol (if it is in
`CurrencyFormatter.majors`) with `CurrencyFormat.fromSymbol()`:

```dart
String fromSymbol = CurrencyFormatter.format(amount, CurrencyFormat.fromSymbol('£')!); // £ 1,910.35

String fromCode = CurrencyFormatter.format(amount, CurrencyFormat.fromCode('gbp')!); // £ 1,910.35
```

## Using custom currencies

Let's say you want to use the following custom currency seamlessly:

```dart
CurrencyFormat khr = CurrencyFormat(
  symbol: '៛',
  symbolSide: SymbolSide.right,
);
```

You can create your own majors list:

```dart
const List<CurrencyFormat> myCurrencies = [
  ...CurrencyFormatter.majorsList,
  khr,
];
```

And use it to get the currency corresponding to a symbol or code, or the local one:

```dart
CurrencyFormat.fromSymbol('៛', myCurrencies); // khr
CurrencyFormat.fromCode('khr', myCurrencies); // khr

// custom local currency
CurrencyFormat? localCurrency() =>
    CurrencyFormat.fromSymbol(CurrencyFormat.localSymbol, myCurrencies);
// or
CurrencyFormat? localCurrency() =>
    CurrencyFormat.fromLocale(null, myCurrencies);
```
