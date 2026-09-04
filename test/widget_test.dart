import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/main.dart';

void main() {
  testWidgets('App inicia e renderiza corretamente', (
    WidgetTester tester,
  ) async {
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

  testWidgets('CTA abre agendamento com seletores', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('AGENDAR AGORA').first);
    await tester.pumpAndSettle();

    expect(find.text('Escolha o serviço'), findsOneWidget);
    expect(find.text('Escolha o barbeiro'), findsOneWidget);
  });

  testWidgets('Atalho abre meus agendamentos', (WidgetTester tester) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Meus agendamentos'));
    await tester.pumpAndSettle();

    expect(find.text('Sem agendamentos'), findsOneWidget);
  });
}
