import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:import_js_library/import_js_library.dart';
import './free_widget_web_wrap.dart';

/// A web implementation of the FreeWidget plugin.
class FreeWidgetWeb {
  FreeWidgetCore core;
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'free_widget',
      const StandardMethodCodec(),
      registrar.messenger,
    );

    importJsLibrary(
      url: './assets/free_widget_core.js',
      flutterPluginName: 'free_widget_core',
    );

    final pluginInstance = FreeWidgetWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'initialize':
        return core.initialize(call.arguments);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'free_widget for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}
