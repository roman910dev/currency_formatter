## [2.0.1] - 2023-05-12

- Upgraded `intl` package to `^0.18.0` to enable support for Flutter 3.10.

## [2.0.0] - 2022-08-21

Major changes.

- Changed dependency from `dart:io` to `universal:io` for better web support.
- `CurrencyFormatter` is now an `abstract` class, so `format()` and `parse()` are `static` methods.
- Included currencies can now be accessed from `CurrencyFormatterSettings`.
- `CurrencyFormatterSettings` now accepts a `symbolSeparator` parameter.
- `CurrencyFormatterSettings` can now be _modified_ using `copyWith()` method.
- `CurrencyFormater().getLocal()` is now `CurrencyFormatterSettings.local`.

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
