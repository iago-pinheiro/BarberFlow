import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/main.dart';

void main() {
  testWidgets('App launches and renders', (WidgetTester tester) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    // Verify the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Home screen content exists', (WidgetTester tester) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    // Find any text on the home screen
    expect(find.text('Bem-vindo'), findsOneWidget);
  });
}