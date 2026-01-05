import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:mobileapp/screens/login/login_page.dart';

void main() {
  testWidgets('User is not logged in test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter));
    await tester.pumpAndSettle();

    expect(find.text('Inloggen'), findsOneWidget);
    expect(find.text('Uitloggen'), findsNothing);

    await tester.tap(find.bySubtype<TextButton>());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets("Test Website", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WEBSITE'));
    await tester.pumpAndSettle();
    // In widget tests, external URL launches can't be verified, but tapping should not cause errors
  });
}
