import 'package:currency_formatter/currency_formatter.dart';

void main() {
  CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
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

  String inUSD = CurrencyFormatter.format(
      amount, CurrencyFormatterSettings.usd); // $ 1,910.93
  String inRUB = CurrencyFormatter.format(
      amount, CurrencyFormatter.majors['rub']!); // 1.910,93 ₽

  String usdSymbol = CurrencyFormatter.majorSymbols['usd']!; // $
  String jpySymbol = CurrencyFormatterSettings.jpy.symbol; // ¥

  String inSystemCurrency = CurrencyFormatter.format(
      amount, CurrencyFormatterSettings.local ?? CurrencyFormatterSettings.usd);

  String fromSymbol = CurrencyFormatter.format(
      amount, CurrencyFormatterSettings.fromSymbol('£')!); // £ 1,910.35

  CurrencyFormatterSettings noSpaceSettings =
      CurrencyFormatterSettings.usd.copyWith(symbolSeparator: '');
  String noSpace =
      CurrencyFormatter.format(amount, noSpaceSettings); // $1,910.93
}
