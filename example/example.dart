import 'package:currency_formatter/currency_formatter.dart';

void main() {
  CurrencyFormatter cf = CurrencyFormatter();

  CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(     // formatter settings for euro
    symbol:'€',
    symbolSide: SymbolSide.left,
    thousandSeparator: '.',
    decimalSeparator: ',',
  );

  num amount = 1910.9347;

  String formatted = cf.format(amount, euroSettings);                     // 1.910,93 €
  String compact = cf.format(amount, euroSettings, compact: true);        // 1,91K €
  String threeDecimal = cf.format(amount, euroSettings, decimal: 3);      // 1.910,945 €

  String inUSD = cf.format(amount, CurrencyFormatter.usd);                // $ 1,910.93
  String inRUB = cf.format(amount, cf.majors['rub']);                     // 1.910,93 ₽

  String jpySymbol = cf.majorSymbols['jpy'];                              // ¥

  String inSystemCurrency = cf.format(amount, cf.getLocal());

  String fromSymbol = cf.format(amount, cf.getFromSymbol('£'));          // £ 1,910.35
}