library native_view;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:native_view_platform_interface/native_view_platform_interface.dart';

typedef NaviteViewCreatedCallback = void Function(
    NativeViewController controller);

class NativeView extends StatefulWidget {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final NaviteViewCreatedCallback onCreated;
  final VoidCallback onLoaded;
  final VoidCallback onClick;

  final ValueChanged<String> onError;

  const NativeView({
    Key key,
    this.gestureRecognizers,
    this.onCreated,
    this.onLoaded,
    this.onClick,
    this.onError,
  }) : super(key: key);

  @override
  _NativeViewState createState() => _NativeViewState();
}

class _NativeViewState extends State<NativeView> {
  final _controller = Completer<NativeViewController>();

  @override
  void dispose() {
    _controller.future.then((ctrl) {
      if (ctrl != null) {
        ctrl.setDispose();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params = <String, dynamic>{};
    return NativeViewPlatform.instance.buildView(
      params,
      widget.gestureRecognizers,
      (viewId) {
        final ctrl = NativeViewController._create(viewId, widget);
        _controller.complete(ctrl);
        widget.onCreated?.call(ctrl);
        NativeViewPlatform.instance.init(params, viewId: viewId);
      },
    );
  }
}

class NativeViewController {
  final int viewId;
  final NativeView widget;

  NativeViewController._create(this.viewId, this.widget)
      : assert(NativeViewPlatform.instance != null) {
    if (widget.onLoaded != null) {
      NativeViewPlatform.instance
          .onLoaded(viewId: viewId)
          .listen((_) => widget.onLoaded());
    }
    if (widget.onError != null) {
      NativeViewPlatform.instance
          .onError(viewId: viewId)
          .listen((msg) => widget.onError(msg.value));
    }
    if (widget.onClick != null) {
      NativeViewPlatform.instance
          .onClick(viewId: viewId)
          .listen((_) => widget.onClick());
    }
  }

  Future<bool> setDispose() {
    return NativeViewPlatform.instance.setDispose(viewId: viewId);
  }
}
