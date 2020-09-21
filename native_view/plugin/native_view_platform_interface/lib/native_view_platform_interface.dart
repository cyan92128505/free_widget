import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_native_view.dart';

enum NativeOperation { copy, move, link, copyMove, copyLink, linkMove, all }

abstract class NativeViewPlatform extends PlatformInterface {
  static final _token = Object();
  final events = StreamController<NativeEvent>.broadcast();
  static NativeViewPlatform _instance = MethodChannelFlutterNative();

  NativeViewPlatform() : super(token: _token);

  /// The default instance of [NativeViewPlatform] to use.
  static NativeViewPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [NativeViewPlatform] when they register themselves.
  static set instance(NativeViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void init(Map<String, dynamic> params, {@required int viewId}) {
    throw UnimplementedError('init');
  }

  Future<bool> setDispose({@required int viewId}) async {
    throw UnimplementedError('setDispose');
  }

  Stream<NativeLoadedEvent> onLoaded({@required int viewId}) {
    return events.stream //
        .where((event) => event.viewId == viewId && event is NativeLoadedEvent)
        .cast<NativeLoadedEvent>();
  }

  Stream<NativeClickEvent> onClick({@required int viewId}) {
    return events.stream
        .where((event) => event.viewId == viewId && event is NativeClickEvent)
        .cast<NativeClickEvent>();
  }

  Stream<NativeErrorEvent> onError({@required int viewId}) {
    return events.stream
        .where((event) => event.viewId == viewId && event is NativeErrorEvent)
        .cast<NativeErrorEvent>();
  }

  Widget buildView(
    Map<String, dynamic> creationParams,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
    PlatformViewCreatedCallback onPlatformViewCreated,
  ) {
    throw UnimplementedError('buildView');
  }

  void dispose() {
    events.close();
  }
}

class NativeEvent<T> {
  final int viewId;
  final T value;

  NativeEvent(this.viewId, [this.value]);
}

class NativeLoadedEvent extends NativeEvent {
  NativeLoadedEvent(int viewId) : super(viewId, null);
}

class NativeClickEvent extends NativeEvent {
  NativeClickEvent(int viewId) : super(viewId, null);
}

class NativeErrorEvent extends NativeEvent<String> {
  NativeErrorEvent(int viewId, String error) : super(viewId, error);
}
