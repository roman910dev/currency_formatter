## [2.2.2] - 2025-01-10

-   Expanded `intl` package support range (`>=0.17.0 <0.21.0`) for better compatibility with different project versions.

## [2.2.1] - 2024-04-04

-   Upgraded dependencies.
-   Added examples.
-   Added tests.

## [2.2.0] - 2023-11-23

-   Added the `CurrencyFormatter.majorsList` list.
-   Deprecated `CurrencyFormatter.majors` and `CurrencyFormatter.symbols` in favor of `CurrencyFormatter.majorsList`.
-   Added the `code` property to `CurrencyFormat`.
-   Modified `CurrencyFormatter.fromSymbol()` to accept an optional `List<CurrencyFormat>` parameter specifying a custom list of currencies.
-   Added `CurrencyFormatter.fromCode()` to get a `CurrencyFormat` from a currency code (e.g. `usd`).
-   Added `CurrencyFormatter.fromLocale()` to get a `CurrencyFormat` from a locale.

## [2.1.0] - 2023-10-01

-   Removed `flutter` dependency. This package is pure Dart.
-   Removed `universal_io` dependency. It was preventing this package support for web to be properly displayed on pub.dev.
-   Increased minimum Dart version to `2.13.0`.
-   Renamed `CurrencyFormatterSettings` to `CurrencyFormatter`. The old name is still available as a deprecated class.
-   `CurrencyFormat.thousandSeparator` and `CurrencyFormat.decimalSeparator` getters are now non-nullable.
-   `CurrencyFormat` constructor is now fully `const`.
-   `CurrencyFormatter.majors` is now `const` and so are all its values.
-   Add `CurrencyFormat` equality operator. Two `CurrencyFormat`s are equal if all their properties are equal.
-   Add `CurrencyFormat.toString()`.

## [2.0.1] - 2023-05-12

-   Upgraded `intl` package to `^0.18.0` to enable support for Flutter 3.10.

## [2.0.0] - 2022-08-21

Major changes.

-   Changed dependency from `dart:io` to `universal:io` for better web support.
-   `CurrencyFormatter` is now an `abstract` class, so `format()` and `parse()` are `static` methods.
-   Included currencies can now be accessed from `CurrencyFormatterSettings`.
-   `CurrencyFormatterSettings` now accepts a `symbolSeparator` parameter.
-   `CurrencyFormatterSettings` can now be _modified_ using `copyWith()` method.
-   `CurrencyFormater().getLocal()` is now `CurrencyFormatterSettings.local`.

## [1.2.1] - 2022-04-20

Added `CurrencyFormatter().parse()`.
Fixed a formatting bug with `thousandSeparator` for negative numbers.

## [1.2.0] - 2021-11-27

Migrated to sound null safety.

## [1.1.1] - 2021-08-25

Fixed bug where `thousandSeparator` would not show.
Fixed bug where with `compact` formatting.

## [1.1.0] - 2020-12-22

Removed [flutter_money_formatter](https://pub.dev/packages/flutter_money_formatter) dependency. Now
it only depends on [intl](https://pub.dev/packages/intl) and its latest version can be used.

## [1.0.1] - 2020-10-04

Improve pub score.

## [1.0.0] - 2020-10-02

Initial release.
