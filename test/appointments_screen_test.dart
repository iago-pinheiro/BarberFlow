import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:barberflow_app/core/providers/appointments_provider.dart';
import 'package:barberflow_app/features/appointments/appointments_screen.dart';

Widget _harness(AppointmentsProvider provider) {
  return MultiProvider(
    providers: [ChangeNotifierProvider.value(value: provider)],
    child: const MaterialApp(home: AppointmentsScreen()),
  );
}

void main() {
  testWidgets('mostra estado vazio sem agendamentos', (WidgetTester tester) async {
    final provider = AppointmentsProvider();
    addTearDown(provider.dispose);

    await tester.pumpWidget(_harness(provider));

    expect(find.text('Sem agendamentos'), findsOneWidget);
    expect(find.text('Agendar agora'), findsOneWidget);
  });

  testWidgets('lista agendamentos ativos com serviços e contatos', (
    WidgetTester tester,
  ) async {
    final provider = AppointmentsProvider();
    addTearDown(provider.dispose);

    await provider.scheduleAppointment(
      serviceId: '1',
      professionalId: 'p1',
      dateTime: DateTime(2026, 1, 15, 14, 0),
      value: 25.0,
      clientName: 'Kaio',
    );

    await tester.pumpWidget(_harness(provider));

    expect(find.text('Ativos'), findsOneWidget);
    expect(find.text('✂️ Corte'), findsOneWidget);
    expect(find.text('Carlos Silva'), findsOneWidget);
    expect(find.text('R\$ 25'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Concluir'), findsOneWidget);
  });

  testWidgets('cancela agendamento e move para o histórico', (
    WidgetTester tester,
  ) async {
    final provider = AppointmentsProvider();
    addTearDown(provider.dispose);

    await provider.scheduleAppointment(
      serviceId: '1',
      professionalId: 'p1',
      dateTime: DateTime(2026, 1, 15, 14, 0),
      value: 25.0,
      clientName: 'Kaio',
    );

    await tester.pumpWidget(_harness(provider));

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Cancelar agendamento?'), findsOneWidget);

    await tester.tap(find.text('Sim, cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Agendamento cancelado.'), findsOneWidget);
    expect(find.text('Cancelado'), findsOneWidget);
    expect(find.text('Cancelar'), findsNothing);
    expect(provider.cancelledAppointments, hasLength(1));
  });

  testWidgets('mantém agendamento ao recusar o cancelamento', (
    WidgetTester tester,
  ) async {
    final provider = AppointmentsProvider();
    addTearDown(provider.dispose);

    await provider.scheduleAppointment(
      serviceId: '1',
      professionalId: 'p1',
      dateTime: DateTime(2026, 1, 15, 14, 0),
      value: 25.0,
      clientName: 'Kaio',
    );

    await tester.pumpWidget(_harness(provider));

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não, manter'));
    await tester.pumpAndSettle();

    expect(find.text('Cancelar'), findsOneWidget);
    expect(provider.scheduledAppointments, hasLength(1));
  });
}