import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_view_platform_interface/native_view_platform_interface.dart';
import 'package:native_view_web/native_view_web.dart';
import 'package:native_view_web/html_element_view.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class NativeViewPlugin extends NativeViewPlatform {
  static final _views = <int, NativeViewWeb>{};
  static final _readyCompleter = Completer<bool>();
  static Future<bool> _isReady;

  static void registerWith(Registrar registrar) {
    final self = NativeViewPlugin();
    _isReady = _readyCompleter.future;
    if (_readyCompleter.isCompleted == false) {
      html.window.addEventListener(
        'native_view_web_ready',
        (_) {
          if (_readyCompleter.isCompleted == false) {
            _readyCompleter.complete(true);
          }
        },
      );
    }
    NativeViewPlatform.instance = self;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('com.jinja.plugins/native_view',
        (viewId) {
      final view = _views[viewId] = NativeViewWeb(viewId);
      return view.container;
    });

    final body = html.window.document.querySelector('body');
    // Hot reload would add it again
    for (html.ScriptElement script in body.querySelectorAll('script'))
      if (script.src.contains('native_view')) {
        script.remove();
      }

    body.append(
      html.ScriptElement()
        ..src = 'assets/packages/native_view_web/assets/native_view.js'
        ..type = 'application/javascript',
    );
  }

  @override
  void init(Map<String, dynamic> params, {@required int viewId}) {
    _views[viewId].init(params);
  }

  @override
  Future<bool> setDispose({@required int viewId}) {
    return _views[viewId].setDispose();
  }

  @override
  Widget buildView(
    Map<String, dynamic> creationParams,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
    PlatformViewCreatedCallback onPlatformViewCreated,
  ) =>
      FutureBuilder<bool>(
        future: _isReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HtmlElementViewEx(
              viewType: 'com.jinja.plugins/native_view',
              onPlatformViewCreated: onPlatformViewCreated,
              creationParams: creationParams,
            );
          } else if (snapshot.hasError)
            return Center(child: Text('Error loading library'));
          else
            return Center(child: CircularProgressIndicator());
        },
      );
}
