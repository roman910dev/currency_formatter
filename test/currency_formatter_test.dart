import 'package:currency_formatter/currency_formatter.dart';
import 'package:test/test.dart';

void main() {
  CurrencyFormat euroSettings = CurrencyFormat(
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
  test('1.910,93 €', () => expect(formatted, '1.910,93 €'));

  String compact =
      CurrencyFormatter.format(amount, euroSettings, compact: true); // 1,91K €
  test('1,91K €', () => expect(compact, '1,91K €'));

  String threeDecimal =
      CurrencyFormatter.format(amount, euroSettings, decimal: 3); // 1.910,935 €
  test('1.910,935 €', () => expect(threeDecimal, '1.910,935 €'));

  num parseFormatted =
      CurrencyFormatter.parse(formatted, euroSettings); // 1910.93
  test('parse 1.910,93 €', () => expect(parseFormatted, 1910.93));

  num parseCompact = CurrencyFormatter.parse(compact, euroSettings); // 1910.0
  test('parse 1,91K €', () => expect(parseCompact, 1910.0));

  num parseThreeDecimal =
      CurrencyFormatter.parse(threeDecimal, euroSettings); // 1910.935
  test('parse 1.910,935 €', () => expect(parseThreeDecimal, 1910.935));

  String inUSD =
      CurrencyFormatter.format(amount, CurrencyFormat.usd); // $ 1,910.93
  test('\$ 1,910.93', () => expect(inUSD, '\$ 1,910.93'));

  String inRUB = CurrencyFormatter.format(
      amount, CurrencyFormat.fromCode('rub')!); // 1.910,93 ₽
  test('1.910,93 ₽', () => expect(inRUB, '1.910,93 ₽'));

  String usdSymbol = CurrencyFormat.fromCode('usd')!.symbol; // $
  test('usd symbol', () => expect(usdSymbol, '\$'));

  String jpySymbol = CurrencyFormat.jpy.symbol; // ¥
  test('jpy symbol', () => expect(jpySymbol, '¥'));

  String fromSymbol = CurrencyFormatter.format(
      amount, CurrencyFormat.fromSymbol('£')!); // £ 1,910.93
  test('from £ symbol', () => expect(fromSymbol, '£ 1,910.93'));

  CurrencyFormat noSpaceSettings =
      CurrencyFormat.usd.copyWith(symbolSeparator: '');
  String noSpace =
      CurrencyFormatter.format(amount, noSpaceSettings); // $1,910.93
  test('no space', () => expect(noSpace, '\$1,910.93'));

  int noDecimalAmount = 3;
  String noDecimal =
      CurrencyFormatter.format(noDecimalAmount, euroSettings); // 3 €
  test('3 €', () => expect(noDecimal, '3 €'));

  String enforceDecimal = CurrencyFormatter.format(
    noDecimalAmount,
    euroSettings,
    enforceDecimals: true,
  ); // 3,00 €
  test('3,00 €', () => expect(enforceDecimal, '3,00 €'));

  CurrencyFormat noSymbolFormat =
      euroSettings.copyWith(symbol: '', symbolSeparator: '');
  String noSymbol =
      CurrencyFormatter.format(amount, noSymbolFormat); // 1.910,93
  test('no symbol', () => expect(noSymbol, '1.910,93'));

  const CurrencyFormat khr = CurrencyFormat(
    code: 'khr',
    symbol: '៛',
    symbolSide: SymbolSide.right,
  );

  const List<CurrencyFormat> myCurrencies = [
    ...CurrencyFormatter.majorsList,
    khr,
  ];
  test('custom currency', () {
    expect(CurrencyFormat.fromSymbol('៛'), null);
    expect(CurrencyFormat.fromSymbol('៛', myCurrencies), khr);
  });

  CurrencyFormat? customLocal = CurrencyFormat.fromLocale(null, myCurrencies);
  test('custom local', () => expect(customLocal, CurrencyFormat.local));

  group('Negative Number Formatting Tests', () {
    test('TRY negative before symbol', () {
      final settings = CurrencyFormat.tryx.copyWith(
        negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
      );
      // tryx default: symbolSide: SymbolSide.left, thousandSeparator: ',', decimalSeparator: '.', symbolSeparator: ' '
      expect(CurrencyFormatter.format(-76231.24, settings), "-₺ 76,231.24");
    });

    test('TRY negative before symbol, no symbol separator', () {
      final settings = CurrencyFormat.tryx.copyWith(
        negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
        symbolSeparator: '',
      );
      // tryx default: symbolSide: SymbolSide.left, thousandSeparator: ',', decimalSeparator: '.', symbolSeparator: ' '
      expect(CurrencyFormatter.format(-76231.24, settings), "-₺76,231.24");
    });

    test('USD negative before symbol', () {
      final settings = CurrencyFormat.usd.copyWith(
        negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
      );
      // usd default: symbolSide: SymbolSide.left, thousandSeparator: ',', decimalSeparator: '.', symbolSeparator: ' '
      expect(CurrencyFormatter.format(-1234.56, settings), "-\$ 1,234.56");
    });

    test('USD negative after symbol (explicit)', () {
      final settings = CurrencyFormat.usd.copyWith(
        negativeSignPlacement: NegativeSignPlacement.afterSymbol,
      );
      expect(CurrencyFormatter.format(-1234.56, settings), "\$ -1,234.56");
    });

    test('USD negative after symbol (default)', () {
      // Relies on default negativeSignPlacement being afterSymbol
      expect(CurrencyFormatter.format(-1234.56, CurrencyFormat.usd),
          "\$ -1,234.56");
    });

    test('EUR negative before symbol (symbol on right)', () {
      final settings = CurrencyFormat.eur.copyWith(
        negativeSignPlacement: NegativeSignPlacement.beforeSymbol,
      );
      // eur default: symbolSide: SymbolSide.right, thousandSeparator: '.', decimalSeparator: ',', symbolSeparator: ' '
      // beforeSymbol only applies if symbolSide is left, otherwise sign is prepended to number.
      expect(CurrencyFormatter.format(-1234.56, settings), "-1.234,56 €");
    });

    test('EUR negative after symbol (explicit)', () {
      final settings = CurrencyFormat.eur.copyWith(
        negativeSignPlacement: NegativeSignPlacement.afterSymbol,
      );
      expect(CurrencyFormatter.format(-1234.56, settings), "-1.234,56 €");
    });

    test('EUR negative after symbol (default)', () {
      // Relies on default negativeSignPlacement being afterSymbol
      expect(CurrencyFormatter.format(-1234.56, CurrencyFormat.eur),
          "-1.234,56 €");
    });
  });
}
