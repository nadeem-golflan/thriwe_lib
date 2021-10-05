import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thriwe_lib/thriwe_lib.dart';

void main() {
  const MethodChannel channel = MethodChannel('thriwe_lib');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ThriweLib.platformVersion, '42');
  });
}
