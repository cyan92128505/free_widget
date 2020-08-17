@JS()
library freee_widget_core.js;

// ignore: avoid_web_libraries_in_flutter
import 'package:js/js.dart';

@JS('free_widget_core')
class FreeWidgetCore {
  external FreeWidgetCore();

  external initialize(dynamic config);
}
