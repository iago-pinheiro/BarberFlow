import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/features/home/home_variant_a.dart';
import 'package:barberflow_app/features/home/home_variant_b.dart';
import 'package:barberflow_app/main.dart';

void main() {
  testWidgets('variante controle renderiza HomeVariantA', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'ab_test_assigned': true,
      'ab_test_variant': 'control',
    });

    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeVariantA), findsOneWidget);
    expect(find.byType(HomeVariantB), findsNothing);
    expect(find.text('Olá!'), findsOneWidget);
    expect(find.text('BarberFlow'), findsNothing);
  });

  testWidgets('variante tratamento renderiza HomeVariantB', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'ab_test_assigned': true,
      'ab_test_variant': 'treatment',
    });

    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeVariantB), findsOneWidget);
    expect(find.byType(HomeVariantA), findsNothing);
    expect(find.text('BarberFlow'), findsOneWidget);
    expect(find.text('OFERTA DA SEMANA'), findsOneWidget);
    expect(find.text('Olá!'), findsNothing);
  });

  testWidgets('sem preferência salva atribui variante automaticamente', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    final hasA = find.byType(HomeVariantA).evaluate().isNotEmpty;
    final hasB = find.byType(HomeVariantB).evaluate().isNotEmpty;

    expect(hasA || hasB, isTrue);
    expect(find.text('AGENDAR AGORA'), findsOneWidget);
  });
}