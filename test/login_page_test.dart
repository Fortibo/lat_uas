import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lat_uas/views/pages/login_page.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  group('LoginPage widget tests', () {
    testWidgets('Should show error when fields are empty', (tester) async {
      await tester.pumpWidget(wrap(const LoginPage()));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Loginn'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('Should show error when credentials are invalid', (tester) async {
      await tester.pumpWidget(wrap(const LoginPage()));

      await tester.enterText(find.byType(TextField).at(0), 'user');
      await tester.enterText(find.byType(TextField).at(1), 'wrong');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Loginn'));
      await tester.pump();

      expect(find.text('Invalid Credentials'), findsOneWidget);
    });

    testWidgets('Should navigate on valid credentials', (tester) async {
      await tester.pumpWidget(wrap(const LoginPage()));

      await tester.enterText(find.byType(TextField).at(0), 'admin');
      await tester.enterText(find.byType(TextField).at(1), 'admin');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Loginn'));
      await tester.pumpAndSettle();

      // After successful login, LoginPage should be replaced
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('Should obscure password field', (tester) async {
      await tester.pumpWidget(wrap(const LoginPage()));

      final passwordField = tester.widget<TextField>(find.byType(TextField).at(1));
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('Should render UI elements correctly', (tester) async {
      await tester.pumpWidget(wrap(const LoginPage()));

      expect(find.text('Login Page'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Loginn'), findsOneWidget);
    });
  });
}
