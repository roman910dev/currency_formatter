import 'package:currency_formatter/currency_formatter.dart';

void main() {
  const CurrencyFormat euroSettings = CurrencyFormat(
    // formatter settings for euro
    code: 'eur',
    symbol: '€',
    symbolSide: SymbolSide.right,
    thousandSeparator: '.',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  num amount = 1910.9347;

  String formatted =
      CurrencyFormatter.format(amount, euroSettings); // 1.910,93 €
  String compact =
      CurrencyFormatter.format(amount, euroSettings, compact: true); // 1,91K €
  String threeDecimal =
      CurrencyFormatter.format(amount, euroSettings, decimal: 3); // 1.910,935 €

  num parseFormatted =
      CurrencyFormatter.parse(formatted, euroSettings); // 1910.93
  num parseCompact = CurrencyFormatter.parse(compact, euroSettings); // 1910.0
  num parseThreeDecimal =
      CurrencyFormatter.parse(threeDecimal, euroSettings); // 1910.935

  String inUSD =
      CurrencyFormatter.format(amount, CurrencyFormat.usd); // $ 1,910.93
  String inRUB = CurrencyFormatter.format(
      amount, CurrencyFormat.fromCode('rub')!); // 1.910,93 ₽

  String jpySymbol = CurrencyFormat.jpy.symbol; // ¥
  String usdSymbol = CurrencyFormat.fromCode('usd')!.symbol; // $

  String inSystemCurrency = CurrencyFormatter.format(
      amount, CurrencyFormat.local ?? CurrencyFormat.usd);

  String fromSymbol = CurrencyFormatter.format(
      amount, CurrencyFormat.fromSymbol('£')!); // £ 1,910.35

  CurrencyFormat noSpaceSettings =
      CurrencyFormat.usd.copyWith(symbolSeparator: '');
  String noSpace =
      CurrencyFormatter.format(amount, noSpaceSettings); // $1,910.93

  int intAmount = 3;
  String noDecimal = CurrencyFormatter.format(intAmount, euroSettings); // 3 €

  String enforceDecimal = CurrencyFormatter.format(
    intAmount,
    euroSettings,
    enforceDecimals: true,
  ); // 3,00 €

  CurrencyFormat noSymbolFormat =
      euroSettings.copyWith(symbol: '', symbolSeparator: '');
  String noSymbol =
      CurrencyFormatter.format(amount, noSymbolFormat); // 1.910,93

  const CurrencyFormat khr = CurrencyFormat(
    code: 'khr',
    symbol: '៛',
    symbolSide: SymbolSide.right,
  );

  const List<CurrencyFormat> myCurrencies = [
    ...CurrencyFormatter.majorsList,
    khr,
  ];

  print('Formatted: $formatted');
  print('Compact: $compact');
  print('Three Decimal: $threeDecimal');
  print('Parsed Formatted: $parseFormatted');
  print('Parsed Compact: $parseCompact');
  print('Parsed Three Decimal: $parseThreeDecimal');
  print('In USD: $inUSD');
  print('In RUB: $inRUB');
  print('JPY Symbol: $jpySymbol');
  print('USD Symbol: $usdSymbol');
  print('In System Currency: $inSystemCurrency');
  print('From Symbol (£): $fromSymbol');
  print('No Space USD: $noSpace');
  print('No Decimal (int amount): $noDecimal');
  print('Enforce Decimal: $enforceDecimal');
  print('No Symbol: $noSymbol');

  CurrencyFormat? khrFromSymbol = CurrencyFormat.fromSymbol('៛');
  print('KHR from symbol (default list): $khrFromSymbol');
  CurrencyFormat? khrFromSymbolMyList =
      CurrencyFormat.fromSymbol('៛', myCurrencies);
  print('KHR from symbol (myCurrencies list): $khrFromSymbolMyList');

  CurrencyFormat? localCurrency() =>
      CurrencyFormat.fromSymbol(CurrencyFormat.localSymbol, myCurrencies);
  print('Local currency from myCurrencies list: ${localCurrency()}');

  // --- Custom Negative Sign Placement ---
  print('\n// --- Custom Negative Sign Placement ---');
  final tryNegativeBefore = CurrencyFormat.tryx.copyWith(
    negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
  );
  double negativeAmountTRY = -76231.24;
  print(
      'Turkish Lira (negative before symbol): ${CurrencyFormatter.format(negativeAmountTRY, tryNegativeBefore)}'); // Expected: -₺76,231.24

  final usdNegativeBefore = CurrencyFormat.usd.copyWith(
    negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
  );
  double negativeAmountUSD = -1234.56;
  print(
      'USD (negative before symbol): ${CurrencyFormatter.format(negativeAmountUSD, usdNegativeBefore)}'); // Expected: -$1,234.56

  final usdNegativeAfter = CurrencyFormat.usd.copyWith(
    negativeSignPlacement: NegativeSignPlacement.afterSymbol,
  );
  print(
      'USD (negative after symbol): ${CurrencyFormatter.format(negativeAmountUSD, usdNegativeAfter)}'); // Expected: $-1,234.56
  
  // Example with default negativeSignPlacement (should be afterSymbol for USD)
  print(
      'USD (negative default placement): ${CurrencyFormatter.format(negativeAmountUSD, CurrencyFormat.usd)}'); // Expected: $-1,234.56

  // Example for EUR (symbol on the right)
  final eurNegativeBefore = CurrencyFormat.eur.copyWith(
    negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
  );
  print(
    'EUR (negative before symbol, symbol right): ${CurrencyFormatter.format(negativeAmountUSD, eurNegativeBefore)}'); // Expected: -1.234,56 €
  
  final eurNegativeAfter = CurrencyFormat.eur.copyWith(
    negativeSignPlacement: NegativeSignPlacement.afterSymbol,
  );
   print(
    'EUR (negative after symbol, symbol right): ${CurrencyFormatter.format(negativeAmountUSD, eurNegativeAfter)}'); // Expected: -1.234,56 €

}
