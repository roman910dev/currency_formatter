library currency_formatter;

import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'dart:math';

class CurrencyFormatter {

  /// Format [amount] using the [settings] of a currency.
  ///
  /// If [compact] is `true` the compact form will be used. e.g. `'$ 1.23K'` instead of `'$ 1,230'`.
  ///
  /// [decimal] is the number of decimal places used when rounding.
  /// e.g. `'$ 45.5'` (1 decimal place), `'$ 45.52'` (2 decimal places).
  ///
  /// If [showThousandSeparator] is set to `false`, the thousand separator won't be shown.
  /// e.g. `'$ 1200'`instead of `'$ 1,200'`.
  ///
  /// If [enforceDecimals] is set to `true`, decimals will be shown even if it is an integer.
  /// e.g. `'$ 5.00'` instead of `'$ 5'`.
  String format(amount, CurrencyFormatterSettings settings,
      {bool compact = false, int decimal = 2, showThousandSeparator = true, enforceDecimals = false}) {
    amount = double.parse('$amount');
    String number;
    String letter = '';

    if (compact) {
      final Map<num, String> letters = {
        pow(10, 12): 'T',
        pow(10, 9): 'B',
        pow(10, 6): 'M',
        pow(10, 3): 'K'
      };

      for (int i = 0; i < letters.length; i++) {
        if (amount.abs() >= letters.keys.elementAt(i)) {
          letter = letters.values.elementAt(i);
          amount /= letters.keys.elementAt(i);
          break;
        }
      }
      number = amount.toStringAsPrecision(3);
      number = number.replaceAll('.', settings.decimalSeparator);
    } else {
      number = amount.toStringAsFixed(decimal);
      if (!enforceDecimals && double.parse(number) == double.parse(number).round()) {
        number = double.parse(number).round().toString();
      }
      number = number.replaceAll('.', settings.decimalSeparator);
      if (showThousandSeparator) {
        String oldNum = number.split(settings.decimalSeparator)[0];
        number = number.contains(settings.decimalSeparator)
            ?
        settings.decimalSeparator + number.split(settings.decimalSeparator)[1]
            :
        '';
        for (int i = 0; i < oldNum.length; i++) {
          number = oldNum[oldNum.length - i - 1] + number;
          if ((i + 1) % 3 == 0 && i < oldNum.length-1) number = settings.thousandSeparator + number;
        }
      }
    }
    switch (settings.symbolSide) {
      case SymbolSide.left:
        return '${settings.symbol} $number$letter';
      case SymbolSide.right:
        return '$number$letter ${settings.symbol}';
      default:
        return '$number$letter';
    }
  }


  /// Get the [CurrencyFormatterSettings] of a currency using its symbol.
  CurrencyFormatterSettings getFromSymbol(String symbol) {
    for (int i = 0; i < majorSymbols.length; i++) {
      print('${majorSymbols.values.elementAt(i)}\t$symbol');
      if (majorSymbols.values.elementAt(i) == symbol)
        return majors.values.elementAt(i);
    }
    return null;
  }


  /// Map that contains the [CurrencyFormatterSettings] from major currencies.
  /// They can be accessed using their abbreviation. e.g. `majors['usd']`.
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


  /// Map that contains the symbols from major currencies.
  /// They can be accessed using their abbreviation. e.g. `majorSymbols['usd']`.
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


  /// Get the [CurrencyFormatterSettings] of the local currency.
  CurrencyFormatterSettings getLocal() => getFromSymbol(
      NumberFormat.simpleCurrency(locale: Platform.localeName).currencySymbol);

  static final CurrencyFormatterSettings usd =
  CurrencyFormatterSettings(symbol: '\$', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings eur =
  CurrencyFormatterSettings(symbol: '€', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings jpy =
  CurrencyFormatterSettings(symbol: '¥', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings gbp =
  CurrencyFormatterSettings(symbol: '£', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings chf =
  CurrencyFormatterSettings(symbol: 'fr', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings cny =
  CurrencyFormatterSettings(symbol: '元', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings sek =
  CurrencyFormatterSettings(symbol: 'kr', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings krw =
  CurrencyFormatterSettings(symbol: '₩', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings inr =
  CurrencyFormatterSettings(symbol: '₹', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings rub =
  CurrencyFormatterSettings(symbol: '₽', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings zar =
  CurrencyFormatterSettings(symbol: 'R', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings tryx =
  CurrencyFormatterSettings(symbol: '₺', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings pln =
  CurrencyFormatterSettings(symbol: 'zł', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings thb =
  CurrencyFormatterSettings(symbol: '฿', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings idr =
  CurrencyFormatterSettings(symbol: 'Rp', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings huf =
  CurrencyFormatterSettings(symbol: 'Ft', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings czk =
  CurrencyFormatterSettings(symbol: 'Kč', symbolSide: SymbolSide.right);

  static final CurrencyFormatterSettings ils =
  CurrencyFormatterSettings(symbol: '₪', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings php =
  CurrencyFormatterSettings(symbol: '₱', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings myr =
  CurrencyFormatterSettings(symbol: 'RM', symbolSide: SymbolSide.left);

  static final CurrencyFormatterSettings ron =
  CurrencyFormatterSettings(symbol: 'L', symbolSide: SymbolSide.right);
}


/// This class contains the formatting settings for a currency.
class CurrencyFormatterSettings {
  /// Symbol of the currency. e.g. '€'
  String symbol;

  /// Whether the symbol is shown before or after the money value, or if it is not shown at all.
  /// e.g. $ 125 ([SymbolSide.left]) or 125 € ([SymbolSide.right]).
  SymbolSide symbolSide;

  /// Thousand separator. e.g. 1,000,000 (`','`) or 1.000.000 (`'.'`). It can be set to any desired [String].
  /// It defaults to `','` for [SymbolSide.left] and to `'.'` for [SymbolSide.right].
  String thousandSeparator;

  /// Decimal separator. e.g. 9.10 (`'.'`) or 9,10 (`','`). It can be set to any desired [String].
  /// It defaults to `'.'` for [SymbolSide.left] and to `','` for [SymbolSide.right].
  String decimalSeparator;

  CurrencyFormatterSettings(
      {@required this.symbol,
        this.symbolSide = SymbolSide.left,
        this.thousandSeparator,
        this.decimalSeparator}) {
    if (this.thousandSeparator == null)
      this.thousandSeparator = this.symbolSide == SymbolSide.left ? ',' : '.';
    if (this.decimalSeparator == null)
      this.decimalSeparator = this.symbolSide == SymbolSide.left ? '.' : ',';
  }
}


/// Enumeration for the three possibilities when writing the currency symbol.
enum SymbolSide { left, right, none }
