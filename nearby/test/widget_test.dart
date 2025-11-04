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

    // Verify that we're now on the main navigation (discover screen should be visible).
    expect(find.text('Discover Screen - Coming Soon'), findsOneWidget);
  });
}
