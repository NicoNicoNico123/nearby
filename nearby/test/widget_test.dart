// This is a basic Flutter widget test for the Nearby app.

import 'package:flutter_test/flutter_test.dart';

import 'package:nearby/main.dart';

void main() {
  testWidgets('Nearby app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NearbyApp());

    // Verify that welcome screen is displayed.
    expect(find.text('Welcome to Nearby'), findsOneWidget);
    expect(find.text('Location-based social dining app'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap the 'Get Started' button and trigger a frame.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify that we're now on the main navigation (feed should be visible by default).
    expect(find.text('Feed'), findsAtLeastNWidgets(1));
    expect(find.text('Discover'), findsAtLeastNWidgets(1));
    expect(find.text('Chat'), findsAtLeastNWidgets(1));
    expect(find.text('Settings'), findsAtLeastNWidgets(1));

    // Since Feed is now the default screen, verify it's loaded
    expect(find.text('Today\'s Recommendations'), findsOneWidget);
  });
}
