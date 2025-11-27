import 'dart:convert';

dynamic tryJsonDecode(String source, {Object? Function(Object? key, Object? value)? reviver, required dynamic defaultValue}) {
  try {
    return jsonDecode(source, reviver: reviver);
  } catch (_) {
    return defaultValue;
  }
}