import 'dart:html';

import 'package:intl/intl.dart';

String get localeName {
  final List<String>? languages = window.navigator.languages;
  return Intl.canonicalizedLocale(
    languages?.isNotEmpty == true
        ? languages!.first
        : window.navigator.language,
  );
}
