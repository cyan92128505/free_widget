import 'dart:async';

import 'package:flutter/services.dart';

class FreeWidget {
  static const MethodChannel _channel = const MethodChannel('free_widget');

  static Future<String> initialize(dynamic config) async {
    final String value = await _channel.invokeMethod('initialize', config);
    return value;
  }
}
