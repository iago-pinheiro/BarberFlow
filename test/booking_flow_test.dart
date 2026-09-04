import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ab_test_assigned': true,
      'ab_test_variant': 'control',
    });
  });

  Future<void> tapVisible(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('fluxo completo de agendamento até a confirmação', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('AGENDAR').first);
    await tester.pumpAndSettle();

    expect(find.text('Escolha o serviço'), findsOneWidget);

    await tester.tap(find.text('✂️ Corte'));
    await tester.pumpAndSettle();

    await tapVisible(tester, 'Carlos Silva');

    await tapVisible(tester, '09:00');

    await tester.enterText(find.byType(TextField).first, 'Kaio');
    await tester.pumpAndSettle();

    await tapVisible(tester, 'Confirmar Agendamento');

    expect(find.text('Agendamento realizado com sucesso!'), findsOneWidget);

    expect(find.text('Meus Agendamentos'), findsOneWidget);
    expect(find.text('Concluir'), findsOneWidget);
    expect(find.text('✂️ Corte'), findsOneWidget);
    expect(find.text('Carlos Silva'), findsOneWidget);
  });

  testWidgets('botão fica desabilitado até preencher todos os campos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('AGENDAR').first);
    await tester.pumpAndSettle();

    expect(find.text('Preencha todos os campos'), findsOneWidget);

    final button = tester.widget<ElevatedButton>(
      find.ancestor(
        of: find.text('Preencha todos os campos'),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('trocar de serviço limpa o horário selecionado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('AGENDAR').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('✂️ Corte'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Carlos Silva');
    await tapVisible(tester, '09:00');

    await tapVisible(tester, '🧔 Barba');

    expect(find.text('Confirmar Agendamento'), findsNothing);
    expect(find.text('Preencha todos os campos'), findsOneWidget);
  });
}