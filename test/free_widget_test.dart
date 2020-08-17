import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_widget/free_widget.dart';

void main() {
  const MethodChannel channel = MethodChannel('free_widget');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('intiailize', () async {
    expect(await FreeWidget.initialize('42'), '42');
  });
}
