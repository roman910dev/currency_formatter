library currency_formatter;
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class CurrencyFormatter {

  String format(amount, CurrencyFormatterSettings settings, {bool compact = false, int decimal = 2}) {
    amount = double.parse('$amount');
    MoneyFormatterSettings formatterSettings = MoneyFormatterSettings(
        symbol: settings.symbol,
        thousandSeparator: settings.thousandSeparator,
        decimalSeparator: settings.decimalSeparator,
        fractionDigits: amount.round() == amount ? 0 : decimal
    );
    String returnable;
    MoneyFormatterOutput formatter = FlutterMoneyFormatter(amount: amount, settings: formatterSettings).output;
    switch (settings.symbolSide) {
      case SymbolSide.left:
        returnable = compact ? formatter.compactSymbolOnLeft : formatter.symbolOnLeft;
        break;
      case SymbolSide.right:
        returnable = compact ? formatter.compactSymbolOnRight : formatter.symbolOnRight;
        break;
      case SymbolSide.none:
        returnable = compact ? formatter.compactNonSymbol : formatter.nonSymbol;
    }
    if (compact && (amount < 0 || settings.decimalSeparator != '.')) {
      List<String> spl = returnable.split(' ');
      int idx = settings.symbolSide == SymbolSide.left ? 1 : 0;
      if (amount < 0) spl[idx] = '-' + spl[idx].replaceAll('-', '');
      if (settings.decimalSeparator != '.') spl[idx] = spl[idx].replaceAll('.', settings.decimalSeparator);
      returnable = spl.join(' ');
    }
    return returnable;
  }

  CurrencyFormatterSettings getFromSymbol(String symbol) {
    for (int i = 0; i < majorSymbols.length; i++) {
      print('${majorSymbols.values.elementAt(i)}\t$symbol');
      if (majorSymbols.values.elementAt(i) == symbol) return majors.values.elementAt(i);
    }
  }

  static final Map<String, CurrencyFormatterSettings> majors = {
    'usd': usd,
    'eur': eur,
    'jpy': jpy,
    'gbp': gbp,
    'chf': chf,
    'cny': cny,
    'sek': sek,
    'krw': krw,
    'inr': inr,
    'rub': rub,
    'zar': zar,
    'try': try_,
    'pln': pln,
    'thb': thb,
    'idr': idr,
    'huf': huf,
    'czk': czk,
    'ils': ils,
    'php': php,
    'myr': myr,
    'ron': ron
  };

  static final Map<String, String> majorSymbols = {
    'usd': '\$',
    'eur': '€',
    'jpy': '¥',
    'gbp': '£',
    'chf': 'fr',
    'cny': '元',
    'sek': 'kr',
    'krw': '₩',
    'inr': '₹',
    'rub': '₽',
    'zar': 'R',
    'try': '₺',
    'pln': 'zł',
    'thb': '฿',
    'idr': 'Rp',
    'huf': 'Ft',
    'czk': 'Kč',
    'ils': '₪',
    'php': '₱',
    'myr': 'RM',
    'ron': 'L'
  };

  CurrencyFormatterSettings getLocal() => getFromSymbol(NumberFormat.simpleCurrency(locale: Platform.localeName).currencySymbol);

  static final CurrencyFormatterSettings usd = CurrencyFormatterSettings(
      symbol: '\$',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings eur = CurrencyFormatterSettings(
      symbol: '€',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings jpy = CurrencyFormatterSettings(
      symbol: '¥',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings gbp = CurrencyFormatterSettings(
      symbol: '£',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings chf = CurrencyFormatterSettings(
      symbol: 'fr',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings cny = CurrencyFormatterSettings(
      symbol: '元',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings sek = CurrencyFormatterSettings(
      symbol: 'kr',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings krw = CurrencyFormatterSettings(
      symbol: '₩',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings inr = CurrencyFormatterSettings(
      symbol: '₹',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings rub = CurrencyFormatterSettings(
      symbol: '₽',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings zar = CurrencyFormatterSettings(
      symbol: 'R',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings try_ = CurrencyFormatterSettings(
      symbol: '₺',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings pln = CurrencyFormatterSettings(
      symbol: 'zł',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings thb = CurrencyFormatterSettings(
      symbol: '฿',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings idr = CurrencyFormatterSettings(
      symbol: 'Rp',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings huf = CurrencyFormatterSettings(
      symbol: 'Ft',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings czk = CurrencyFormatterSettings(
      symbol: 'Kč',
      symbolSide: SymbolSide.right
  );

  static final CurrencyFormatterSettings ils = CurrencyFormatterSettings(
      symbol: '₪',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings php = CurrencyFormatterSettings(
      symbol: '₱',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings myr = CurrencyFormatterSettings(
      symbol: 'RM',
      symbolSide: SymbolSide.left
  );

  static final CurrencyFormatterSettings ron = CurrencyFormatterSettings(
      symbol: 'L',
      symbolSide: SymbolSide.right
  );
}

class CurrencyFormatterSettings {
  String symbol;
  SymbolSide symbolSide;
  String thousandSeparator;
  String decimalSeparator;

  CurrencyFormatterSettings({@required this.symbol, this.symbolSide = SymbolSide.left, this.thousandSeparator, this.decimalSeparator}){
    if (this.thousandSeparator == null) this.thousandSeparator = this.symbolSide == SymbolSide.left ? ',' : '.';
    if (this.decimalSeparator == null) this.decimalSeparator = this.symbolSide == SymbolSide.left ? '.' : ',';
  }
}

enum SymbolSide {left, right, none}
