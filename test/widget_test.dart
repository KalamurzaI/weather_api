import 'package:flutter_test/flutter_test.dart';

import 'package:weather_api/main.dart';

void main() {
  testWidgets('TestHttp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TestHttp());
  });
}