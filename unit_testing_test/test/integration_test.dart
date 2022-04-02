

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:unit_testing_test/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("message should change integration", () {
    testWidgets("tap on button, verify message", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // expect initial value of message to be "Hello World"
      expect(find.text("Hello World"), findsOneWidget);

      // Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Change');

      await tester.tap(fab);
      // Trigger a frame.
      await tester.pumpAndSettle();
      // Verify value of message is now equal to "Hello"
      expect(find.text('Hello'), findsOneWidget);
    });
  });
}