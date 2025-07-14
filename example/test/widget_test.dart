// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:video_thumbnailer_example/main.dart';

void main() {
  testWidgets('Verify Platform Version text appears', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Allow time for async operations like platform version fetching
    await tester.pumpAndSettle();

    // Verify that the platform version text is shown
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            widget.data!.startsWith('Platform Version:'),
      ),
      findsOneWidget,
    );

    // Verify the presence of the button
    expect(find.text('Pick Video & Generate Thumbnail'), findsOneWidget);
  });
}
