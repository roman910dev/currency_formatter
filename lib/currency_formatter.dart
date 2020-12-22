library currency_formatter;
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'dart:math';

class CurrencyFormatter {

  String format(amount, CurrencyFormatterSettings settings, {bool compact = false, int decimal = 2}) {
    amount = double.parse('$amount');
    String number;
    String letter = '';

    if (compact) {
      final Map<num, String> letters = {
        pow(10,9): 'B',
        pow(10,6): 'M',
        pow(10,3): 'K'
      };

      for (int i = 0; i < letters.length; i++) {
        if (amount.abs() >= letters.keys.elementAt(i)) {
          letter = letters.values.elementAt(i);
          amount /= letters.keys.elementAt(i);
          break;
        }
        number = amount.toStringAsPrecision(3)+letter;
      }
    } else {
      number = amount.toStringAsFixed(decimal);
    }
    number = number.replaceAll('.', settings.decimalSeparator);
    switch (settings.symbolSide) {
      case SymbolSide.left:
        return '${settings.symbol} $number$letter';
      case SymbolSide.right:
        return '$number$letter ${settings.symbol}';
      default:
        return '$number$letter';
    }
  }

  CurrencyFormatterSettings getFromSymbol(String symbol) {
    for (int i = 0; i < majorSymbols.length; i++) {
      print('${majorSymbols.values.elementAt(i)}\t$symbol');
      if (majorSymbols.values.elementAt(i) == symbol) return majors.values.elementAt(i);
    }
    return null;
  }

  final Map<String, CurrencyFormatterSettings> majors = {
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
    'try': tryx,
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

  final Map<String, String> majorSymbols = {
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

  static final CurrencyFormatterSettings tryx = CurrencyFormatterSettings(
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
