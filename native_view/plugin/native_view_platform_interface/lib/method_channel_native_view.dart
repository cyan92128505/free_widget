import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'native_view_platform_interface.dart';

class MethodChannelFlutterNative extends NativeViewPlatform {
  @override
  void init(Map<String, dynamic> params, {@required int viewId}) {
    throw UnsupportedError(
        'NativeView: $defaultTargetPlatform is not supported');
  }

  @override
  Future<bool> setDispose({@required int viewId}) {
    throw UnsupportedError(
        'NativeView: $defaultTargetPlatform is not supported');
  }

  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated) {
    return Text('NativeView: $defaultTargetPlatform is not supported');
  }
}
