@JS('native_view_web')
library native_view_web;

import 'dart:async';
import 'dart:html';
import 'package:js/js.dart';

import 'package:native_view_platform_interface/native_view_platform_interface.dart';

@JS('initialize')
external void _nativeInitialize(
  dynamic viewId,
  dynamic container,
  Function onLoaded,
  Function onError,
  Function onClick,
);

@JS('dispose')
external bool _nativeDispose(dynamic container, int viewId);

class NativeViewWeb {
  final int viewId;
  DivElement container;

  NativeViewWeb(this.viewId) {
    container = DivElement()
      ..id = 'native-view-container-$viewId'
      ..style.border = 'none'
      ..append(ScriptElement()..text = 'native_view_web.triggerBuild($viewId);')
      ..addEventListener('build', (_) {
        _nativeInitialize(
          viewId,
          container,
          allowInterop(_onLoaded),
          allowInterop(_onError),
          allowInterop(_onClick),
        );
      });
  }

  void init(Map<String, dynamic> params) {
    // param = params['param'];
  }

  Future<bool> setDispose() async {
    _nativeDispose(container, viewId);
    return true;
  }

  Future<List<dynamic>> pickFiles(bool multiple) {
    final completer = Completer<List<dynamic>>();
    final picker = FileUploadInputElement();
    picker.multiple = multiple;
    picker.onChange.listen((_) => completer.complete(picker.files));
    picker.click();
    return completer.future;
  }

  void _onLoaded() =>
      NativeViewPlatform.instance.events.add(NativeLoadedEvent(viewId));

  void _onError(String error) =>
      NativeViewPlatform.instance.events.add(NativeErrorEvent(viewId, error));

  void _onClick() =>
      NativeViewPlatform.instance.events.add(NativeClickEvent(viewId));
}
