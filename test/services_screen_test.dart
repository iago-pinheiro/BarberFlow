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

  Future<void> openServices(WidgetTester tester) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver todos').first);
    await tester.pumpAndSettle();
  }

  testWidgets('lista todos os serviços inicialmente', (WidgetTester tester) async {
    await openServices(tester);

    expect(find.text('✂️ Corte'), findsOneWidget);
    expect(find.text('🧔 Barba'), findsOneWidget);
    expect(find.text('✨ Sobrancelha'), findsOneWidget);
    expect(find.text('R\$ 25'), findsOneWidget);
  });

  testWidgets('filtra por categoria Barba', (WidgetTester tester) async {
    await openServices(tester);

    await tester.tap(find.text('Barba').first);
    await tester.pumpAndSettle();

    expect(find.text('🧔 Barba'), findsOneWidget);
    expect(find.text('✂️ Corte'), findsNothing);
    expect(find.text('✨ Sobrancelha'), findsNothing);
  });

  testWidgets('filtra por categoria Corte + Barba (combo)', (
    WidgetTester tester,
  ) async {
    await openServices(tester);

    await tester.tap(find.text('Combo').first);
    await tester.pumpAndSettle();

    expect(find.text('✂️🧔 Corte + Barba'), findsOneWidget);
    expect(find.text('✂️ Corte'), findsNothing);
    expect(find.text('🧔 Barba'), findsNothing);
  });

  testWidgets('tocar em um serviço vai para o agendamento já selecionado', (
    WidgetTester tester,
  ) async {
    await openServices(tester);

    await tester.tap(find.text('✂️ Corte'));
    await tester.pumpAndSettle();

    expect(find.text('Escolha o barbeiro'), findsOneWidget);
    expect(find.text('Carlos Silva'), findsOneWidget);
    expect(find.text('Ricardo Almeida'), findsOneWidget);
  });
}