library currency_formatter;

import 'package:intl/intl.dart';
import './src/locale.dart'
    if (dart.library.html) './src/locale_html.dart'
    if (dart.library.io) './src/locale_io.dart';

abstract class CurrencyFormatter {
  static const Map<int, String> _letters = {
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
  static String format(
    amount,
    CurrencyFormat settings, {
    bool compact = false,
    int decimal = 2,
    showThousandSeparator = true,
    enforceDecimals = false,
  }) {
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
      number = number.replaceAll('.', settings.decimalSeparator);
    } else {
      number = amount.toStringAsFixed(decimal);
      if (!enforceDecimals &&
          double.parse(number) == double.parse(number).round()) {
        number = double.parse(number).round().toString();
      }
      number = number.replaceAll('.', settings.decimalSeparator);
      if (showThousandSeparator) {
        String oldNum = number.split(settings.decimalSeparator)[0];
        number = number.contains(settings.decimalSeparator)
            ? settings.decimalSeparator +
                number.split(settings.decimalSeparator)[1]
            : '';
        for (int i = 0; i < oldNum.length; i++) {
          number = oldNum[oldNum.length - i - 1] + number;
          if ((i + 1) % 3 == 0 &&
              i < oldNum.length - (oldNum.startsWith('-') ? 2 : 1)) {
            number = settings.thousandSeparator + number;
          }
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
  static num parse(String input, CurrencyFormat settings) {
    String txt = input
        .replaceFirst(settings.thousandSeparator, '')
        .replaceFirst(settings.decimalSeparator, '.')
        .replaceFirst(settings.symbol, '')
        .replaceFirst(settings.symbolSeparator, '')
        .trim();

    int multiplicator = 1;
    for (int mult in _letters.keys) {
      final String letter = _letters[mult]!;
      if (txt.endsWith(letter)) {
        txt = txt.replaceFirst(letter, '');
        multiplicator = mult;
        break;
      }
    }

    return num.parse(txt) * multiplicator;
  }

  /// Map that contains the [CurrencyFormat] from major currencies.
  /// They can be accessed using their abbreviation. e.g. `majors['usd']`.
  static const Map<String, CurrencyFormat> majors = {
    'usd': CurrencyFormat.usd,
    'eur': CurrencyFormat.eur,
    'jpy': CurrencyFormat.jpy,
    'gbp': CurrencyFormat.gbp,
    'chf': CurrencyFormat.chf,
    'cny': CurrencyFormat.cny,
    'sek': CurrencyFormat.sek,
    'krw': CurrencyFormat.krw,
    'inr': CurrencyFormat.inr,
    'rub': CurrencyFormat.rub,
    'zar': CurrencyFormat.zar,
    'try': CurrencyFormat.tryx,
    'pln': CurrencyFormat.pln,
    'thb': CurrencyFormat.thb,
    'idr': CurrencyFormat.idr,
    'huf': CurrencyFormat.huf,
    'czk': CurrencyFormat.czk,
    'ils': CurrencyFormat.ils,
    'php': CurrencyFormat.php,
    'myr': CurrencyFormat.myr,
    'ron': CurrencyFormat.ron
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
    'ron': 'L',
    'eth': 'Ξ',
    'btc': '₿',
    'ada': '₳',
    'matic': 'MATIC',
    'sol': 'SOL',
    'dai': '◈',
  };
}

@Deprecated('Use \'CurrencyFormat\' instead')
typedef CurrencyFormatterSettings = CurrencyFormat;

/// This class contains the formatting settings for a currency.
class CurrencyFormat {
  /// Symbol of the currency. e.g. '€'
  final String symbol;

  /// Whether the symbol is shown before or after the money value, or if it is not shown at all.
  /// e.g. $ 125 ([SymbolSide.left]) or 125 € ([SymbolSide.right]).
  final SymbolSide symbolSide;

  final String? _thousandSeparator;

  final String? _decimalSeparator;

  /// Character(s) between the number and the currency symbol. e.g. $ 9.10 (`' '`) or $9.10 (`''`).
  /// It defaults to a normal space (`' '`).
  final String symbolSeparator;

  const CurrencyFormat({
    required this.symbol,
    this.symbolSide = SymbolSide.left,
    String? thousandSeparator,
    String? decimalSeparator,
    this.symbolSeparator = ' ',
  })  : _thousandSeparator = thousandSeparator,
        _decimalSeparator = decimalSeparator;

  /// Thousand separator. e.g. 1,000,000 (`','`) or 1.000.000 (`'.'`). It can be set to any desired [String].
  /// It defaults to `','` for [SymbolSide.left] and to `'.'` for [SymbolSide.right].
  String get thousandSeparator =>
      _thousandSeparator ?? (symbolSide == SymbolSide.left ? ',' : '.');

  /// Decimal separator. e.g. 9.10 (`'.'`) or 9,10 (`','`). It can be set to any desired [String].
  /// It defaults to `'.'` for [SymbolSide.left] and to `','` for [SymbolSide.right].
  String get decimalSeparator =>
      _decimalSeparator ?? (symbolSide == SymbolSide.left ? '.' : ',');

  /// Returns the same [CurrencyFormat] but with some changed parameters.
  CurrencyFormat copyWith({
    String? symbol,
    SymbolSide? symbolSide,
    String? thousandSeparator,
    String? decimalSeparator,
    String? symbolSeparator,
  }) =>
      CurrencyFormat(
        symbol: symbol ?? this.symbol,
        symbolSide: symbolSide ?? this.symbolSide,
        thousandSeparator: thousandSeparator ?? this.thousandSeparator,
        decimalSeparator: decimalSeparator ?? this.decimalSeparator,
        symbolSeparator: symbolSeparator ?? this.symbolSeparator,
      );

  /// Get the [CurrencyFormat] of a currency using its symbol.
  static CurrencyFormat? fromSymbol(String symbol) {
    for (int i = 0; i < CurrencyFormatter.majorSymbols.length; i++) {
      if (CurrencyFormatter.majorSymbols.values.elementAt(i) == symbol) {
        return CurrencyFormatter.majors.values.elementAt(i);
      }
    }
    return null;
  }

  /// Get the [CurrencyFormat] of the local currency.
  static CurrencyFormat? get local => fromSymbol(
      NumberFormat.simpleCurrency(locale: localeName).currencySymbol);

  /// The [CurrencyFormat] of the US Dollar.
  static const CurrencyFormat usd =
      CurrencyFormat(symbol: '\$', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Euro.
  static const CurrencyFormat eur =
      CurrencyFormat(symbol: '€', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the Japanese Yen.
  static const CurrencyFormat jpy =
      CurrencyFormat(symbol: '¥', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the British Pound.
  static const CurrencyFormat gbp =
      CurrencyFormat(symbol: '£', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Swiss Franc.
  static const CurrencyFormat chf =
      CurrencyFormat(symbol: 'fr', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the Chinese Yuan.
  static const CurrencyFormat cny =
      CurrencyFormat(symbol: '元', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Swedish Krona.
  static const CurrencyFormat sek =
      CurrencyFormat(symbol: 'kr', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the South Korean Won.
  static const CurrencyFormat krw =
      CurrencyFormat(symbol: '₩', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Indian Rupee.
  static const CurrencyFormat inr =
      CurrencyFormat(symbol: '₹', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Russian Ruble.
  static const CurrencyFormat rub =
      CurrencyFormat(symbol: '₽', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the South African Rand.
  static const CurrencyFormat zar =
      CurrencyFormat(symbol: 'R', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Turkish Lira.
  static const CurrencyFormat tryx =
      CurrencyFormat(symbol: '₺', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Polish Zloty.
  static const CurrencyFormat pln =
      CurrencyFormat(symbol: 'zł', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the Thai Baht.
  static const CurrencyFormat thb =
      CurrencyFormat(symbol: '฿', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Indonesian Rupiah.
  static const CurrencyFormat idr =
      CurrencyFormat(symbol: 'Rp', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Hungarian Forint.
  static const CurrencyFormat huf =
      CurrencyFormat(symbol: 'Ft', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the Czech Koruna.
  static const CurrencyFormat czk =
      CurrencyFormat(symbol: 'Kč', symbolSide: SymbolSide.right);

  /// The [CurrencyFormat] of the Israeli New Shekel.
  static const CurrencyFormat ils =
      CurrencyFormat(symbol: '₪', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Philippine Peso.
  static const CurrencyFormat php =
      CurrencyFormat(symbol: '₱', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Malaysian Ringgit.
  static const CurrencyFormat myr =
      CurrencyFormat(symbol: 'RM', symbolSide: SymbolSide.left);

  /// The [CurrencyFormat] of the Romanian Leu.
  static const CurrencyFormat ron =
      CurrencyFormat(symbol: 'L', symbolSide: SymbolSide.right);
  
  /// The [CurrencyFormat] of Ethereum.
  static const CurrencyFormat eth =
      CurrencyFormat(symbol: 'Ξ', symbolSide: SymbolSide.right);
  
  /// The [CurrencyFormat] of Bitcoin.
  static const CurrencyFormat btc =
      CurrencyFormat(symbol: '₿', symbolSide: SymbolSide.left);
  
  /// The [CurrencyFormat] of Cardano.
  static const CurrencyFormat ada =
      CurrencyFormat(symbol: '₳', symbolSide: SymbolSide.left);
  
  /// The [CurrencyFormat] of Polygon's Matic.
  static const CurrencyFormat matic =
      CurrencyFormat(symbol: 'MATIC', symbolSide: SymbolSide.right);
  
  /// The [CurrencyFormat] of Solana.
  static const CurrencyFormat sol =
      CurrencyFormat(symbol: 'SOL', symbolSide: SymbolSide.right);
  
  /// The [CurrencyFormat] of Dai.
  static const CurrencyFormat dai =
      CurrencyFormat(symbol: '◈', symbolSide: SymbolSide.right);

  @override
  String toString() =>
      'CurrencyFormat<${CurrencyFormatter.format(9999.99, this)}>';

  @override
  operator ==(other) =>
      other is CurrencyFormat &&
      other.symbol == symbol &&
      other.symbolSide == symbolSide &&
      other.thousandSeparator == thousandSeparator &&
      other.decimalSeparator == decimalSeparator &&
      other.symbolSeparator == symbolSeparator;

  @override
  int get hashCode =>
      symbol.hashCode ^
      symbolSide.hashCode ^
      thousandSeparator.hashCode ^
      decimalSeparator.hashCode ^
      symbolSeparator.hashCode;
}

/// Enumeration for the three possibilities when writing the currency symbol.
enum SymbolSide { left, right, none }
