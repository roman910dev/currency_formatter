library currency_formatter;

import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' show Platform;

abstract class CurrencyFormatter {
  static final Map<num, String> _letters = {
    1000000000000: 'T',
    1000000000: 'B',
    1000000: 'M',
    1000: 'K'
  };

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
  static String format(amount, CurrencyFormatterSettings settings,
      {bool compact = false,
      int decimal = 2,
      showThousandSeparator = true,
      enforceDecimals = false}) {
    amount = double.parse('$amount');
    late String number;
    String letter = '';

    if (compact) {
      for (int i = 0; i < _letters.length; i++) {
        if (amount.abs() >= _letters.keys.elementAt(i)) {
          letter = _letters.values.elementAt(i);
          amount /= _letters.keys.elementAt(i);
          break;
        }
      }
      number = amount.toStringAsPrecision(3);
      number = number.replaceAll('.', settings.decimalSeparator!);
    } else {
      number = amount.toStringAsFixed(decimal);
      if (!enforceDecimals &&
          double.parse(number) == double.parse(number).round()) {
        number = double.parse(number).round().toString();
      }
      number = number.replaceAll('.', settings.decimalSeparator!);
      if (showThousandSeparator) {
        String oldNum = number.split(settings.decimalSeparator!)[0];
        number = number.contains(settings.decimalSeparator!)
            ? settings.decimalSeparator! +
                number.split(settings.decimalSeparator!)[1]
            : '';
        for (int i = 0; i < oldNum.length; i++) {
          number = oldNum[oldNum.length - i - 1] + number;
          if ((i + 1) % 3 == 0 &&
              i < oldNum.length - (oldNum.startsWith('-') ? 2 : 1))
            number = settings.thousandSeparator! + number;
        }
      }
    }
    switch (settings.symbolSide) {
      case SymbolSide.left:
        return '${settings.symbol}${settings.symbolSeparator}$number$letter';
      case SymbolSide.right:
        return '$number$letter${settings.symbolSeparator}${settings.symbol}';
      default:
        return '$number$letter';
    }
  }

  /// Parse a formatted string to a number.
  static num parse(String input, CurrencyFormatterSettings settings) {
    String txt = input
        .replaceFirst(settings.thousandSeparator ?? '', '')
        .replaceFirst(settings.decimalSeparator ?? '', '.')
        .replaceFirst(settings.symbol, '')
        .replaceFirst(settings.symbolSeparator, '')
        .trim();

    String _letter = '';
    for (String letter in _letters.values) {
      if (txt.endsWith(letter)) {
        txt = txt.replaceFirst(letter, '');
        _letter = letter;
        break;
      }
    }

    return num.parse(txt) *
        _letters.keys
            .firstWhere((e) => _letters[e] == _letter, orElse: () => 1);
  }

  /// Map that contains the [CurrencyFormatterSettings] from major currencies.
  /// They can be accessed using their abbreviation. e.g. `majors['usd']`.
  static final Map<String, CurrencyFormatterSettings> majors = {
    'usd': CurrencyFormatterSettings.usd,
    'eur': CurrencyFormatterSettings.eur,
    'jpy': CurrencyFormatterSettings.jpy,
    'gbp': CurrencyFormatterSettings.gbp,
    'chf': CurrencyFormatterSettings.chf,
    'cny': CurrencyFormatterSettings.cny,
    'sek': CurrencyFormatterSettings.sek,
    'krw': CurrencyFormatterSettings.krw,
    'inr': CurrencyFormatterSettings.inr,
    'rub': CurrencyFormatterSettings.rub,
    'zar': CurrencyFormatterSettings.zar,
    'try': CurrencyFormatterSettings.tryx,
    'pln': CurrencyFormatterSettings.pln,
    'thb': CurrencyFormatterSettings.thb,
    'idr': CurrencyFormatterSettings.idr,
    'huf': CurrencyFormatterSettings.huf,
    'czk': CurrencyFormatterSettings.czk,
    'ils': CurrencyFormatterSettings.ils,
    'php': CurrencyFormatterSettings.php,
    'myr': CurrencyFormatterSettings.myr,
    'ron': CurrencyFormatterSettings.ron
  };

  /// Map that contains the symbols from major currencies.
  /// They can be accessed using their abbreviation. e.g. `majorSymbols['usd']`.
  static const Map<String, String> majorSymbols = {
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
  String? thousandSeparator;

  /// Decimal separator. e.g. 9.10 (`'.'`) or 9,10 (`','`). It can be set to any desired [String].
  /// It defaults to `'.'` for [SymbolSide.left] and to `','` for [SymbolSide.right].
  String? decimalSeparator;

  /// Character(s) between the number and the currency symbol. e.g. $ 9.10 (`' '`) or $9.10 (`''`).
  /// It defaults to a normal space (`' '`).
  String symbolSeparator;

  CurrencyFormatterSettings(
      {required this.symbol,
      this.symbolSide = SymbolSide.left,
      this.thousandSeparator,
      this.decimalSeparator,
      this.symbolSeparator = ' '}) {
    if (this.thousandSeparator == null)
      this.thousandSeparator = this.symbolSide == SymbolSide.left ? ',' : '.';
    if (this.decimalSeparator == null)
      this.decimalSeparator = this.symbolSide == SymbolSide.left ? '.' : ',';
  }

  // Returns the same [CurrencyFormatterSettings] but with some changed parameters.
  CurrencyFormatterSettings copyWith({
    String? symbol,
    SymbolSide? symbolSide,
    String? thousandSeparator,
    String? decimalSeparator,
    String? symbolSeparator,
  }) =>
      CurrencyFormatterSettings(
          symbol: symbol ?? this.symbol,
          symbolSide: symbolSide ?? this.symbolSide,
          thousandSeparator: thousandSeparator ?? this.thousandSeparator,
          decimalSeparator: decimalSeparator ?? this.decimalSeparator,
          symbolSeparator: symbolSeparator ?? this.symbolSeparator);

  /// Get the [CurrencyFormatterSettings] of a currency using its symbol.
  static CurrencyFormatterSettings? fromSymbol(String symbol) {
    for (int i = 0; i < CurrencyFormatter.majorSymbols.length; i++) {
      if (CurrencyFormatter.majorSymbols.values.elementAt(i) == symbol)
        return CurrencyFormatter.majors.values.elementAt(i);
    }
    return null;
  }

  /// Get the [CurrencyFormatterSettings] of the local currency.
  static CurrencyFormatterSettings? get local => fromSymbol(
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

/// Enumeration for the three possibilities when writing the currency symbol.
enum SymbolSide { left, right, none }
