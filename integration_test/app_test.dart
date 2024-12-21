// This is a basic Flutter widget integration_test.
//
// To perform an interaction with a widget in your integration_test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:gift_management_app/main.dart';

void main() {
  testWidgets('Integration Testing Hedieaty', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Navigate to Login Page
    final goToLoginButton =
        find.widgetWithText(ElevatedButton, 'Already have an account? Login');
    await tester.tap(goToLoginButton);
    await tester.pumpAndSettle();

    // Fill user credentials and sign in
    final emailField = find.byType(TextFormField).at(0);
    await tester.enterText(emailField, 'ahmed@gmail.com');

    final passwordField = find.byType(TextFormField).at(1);
    await tester.enterText(passwordField, 'password');

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.tap(signInButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to the My Events Page
    final goToEventsButton =
        find.widgetWithText(ElevatedButton, 'Go to Your Events');
    await tester.tap(goToEventsButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to the Add Event Page
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill Event details and create new event
    final eventNameField = find.byType(TextFormField).at(0);
    await tester.enterText(eventNameField, 'Birthday Party');

    final eventLocationField = find.byType(TextFormField).at(1);
    await tester.enterText(eventLocationField, '123 Party St, Fun City');

    final eventDescriptionField = find.byType(TextFormField).at(2);
    await tester.enterText(
        eventDescriptionField, 'A fun birthday party with games and cake.');

    final eventDateButton = find.text('Pick a date');
    await tester.tap(eventDateButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('27').first);
    await tester.tap(find.text('OK'));

    final eventSaveButton = find.text('Save & Publish');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(eventSaveButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Event published successfully'), findsOneWidget);

    // Click on the event to add a gift to it
    await tester.tap(find.text('Birthday Party'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to the Add Gift Page
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill Gift details and create new event
    final giftNameField = find.byType(TextFormField).at(0);
    await tester.enterText(giftNameField, 'Gift Name');

    final giftDescriptionField = find.byType(TextFormField).at(1);
    await tester.enterText(
        giftDescriptionField, 'This is a description of the gift.');

    final giftCategoryField = find.byType(TextFormField).at(2);
    await tester.enterText(giftCategoryField, 'Category');

    final giftPriceField = find.byType(TextFormField).at(3);
    await tester.enterText(giftPriceField, '50');

    final giftImageUrlField = find.byType(TextFormField).at(4);
    await tester.enterText(giftImageUrlField,
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfK1JKhtA-rhvTSvE1jORjH579iWvGwfFbXA&s');

    final giftSaveButton = find.text('Save Gift');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(giftSaveButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Gift saved successfully'), findsOneWidget);
  });
}
