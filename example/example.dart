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

  CurrencyFormat.fromSymbol('៛'); // null
  CurrencyFormat.fromSymbol('៛', myCurrencies); // khr

  CurrencyFormat? localCurrency() =>
      CurrencyFormat.fromSymbol(CurrencyFormat.localSymbol, myCurrencies);
}
