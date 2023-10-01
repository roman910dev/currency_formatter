import 'package:currency_formatter/currency_formatter.dart';

void main() {
  const CurrencyFormat euroSettings = CurrencyFormat(
    // formatter settings for euro
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
      amount, CurrencyFormatter.majors['rub']!); // 1.910,93 ₽

  String usdSymbol = CurrencyFormatter.majorSymbols['usd']!; // $
  String jpySymbol = CurrencyFormat.jpy.symbol; // ¥

  String inSystemCurrency = CurrencyFormatter.format(
      amount, CurrencyFormat.local ?? CurrencyFormat.usd);

  String fromSymbol = CurrencyFormatter.format(
      amount, CurrencyFormat.fromSymbol('£')!); // £ 1,910.35

  CurrencyFormat noSpaceSettings =
      CurrencyFormat.usd.copyWith(symbolSeparator: '');
  String noSpace =
      CurrencyFormatter.format(amount, noSpaceSettings); // $1,910.93
}
