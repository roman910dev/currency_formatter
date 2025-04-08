import 'dart:js_interop';

import 'package:web/web.dart';
import 'package:intl/intl.dart';

String get localeName {
  final List<String> languages =
      window.navigator.languages.toDart.map((e) => e.toDart).toList();
  return Intl.canonicalizedLocale(
    languages.isNotEmpty ? languages.first : window.navigator.language,
  );
}
