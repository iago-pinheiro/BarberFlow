import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/main.dart';

void main() {
  testWidgets('App inicia e renderiza corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Home exibe nome do app', (WidgetTester tester) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    final hasBarberFlow = find.text('BarberFlow').evaluate().isNotEmpty;
    final hasOla = find.text('Olá!').evaluate().isNotEmpty;
    expect(hasBarberFlow || hasOla, isTrue);
  });
}