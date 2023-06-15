// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stals_frontend/main.dart';
import 'package:stals_frontend/utils/export_screens.dart';

void main() {
  testWidgets('Sign In', (WidgetTester signInTester) async {
    final emailField = find.byKey(ValueKey("emailKey"));
    final passField = find.byKey(ValueKey("passKey"));
    final submitBtn = find.byKey(ValueKey("SubmitBtn"));
    // Build our app and trigger a frame.
    await signInTester.pumpWidget(const MyApp());
    await signInTester.pumpWidget(const SignInPage());
    await signInTester.enterText(emailField, "customer@test.com");
    await signInTester.enterText(passField, "customerA1");
    await signInTester.tap(submitBtn);
    await signInTester.pump();
    // Verify that our counter starts at 0.
    expect(find.text('customer@test.com'), findsOneWidget);
    expect(find.text('customer@test.com'), findsOneWidget);
  });
}
