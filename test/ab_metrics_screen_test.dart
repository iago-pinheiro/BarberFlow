import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/core/providers/app_provider.dart';
import 'package:barberflow_app/features/home/ab_test_metrics_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ab_test_assigned': true,
      'ab_test_variant': 'control',
    });
  });

  Future<AppProvider> makeProvider() async {
    final provider = AppProvider();
    await provider.initialize();
    await provider.trackEvent('screen_view');
    await provider.trackEvent('booking_confirmed');
    return provider;
  }

  Future<void> pumpScreen(WidgetTester tester, AppProvider provider) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider.value(value: provider)],
        child: const MaterialApp(home: ABTestMetricsScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('exibe a variante atual e o relatório das duas variantes', (
    WidgetTester tester,
  ) async {
    final provider = await makeProvider();

    await pumpScreen(tester, provider);

    expect(find.text('Teste A/B'), findsOneWidget);
    expect(find.text('Variante A (Controle)'), findsNWidgets(2));
    expect(find.text('Variante B (Tratamento)'), findsOneWidget);
    expect(find.text('Taxa de Conversão'), findsNWidgets(2));
    expect(find.text('100.0%'), findsNWidgets(2));
    expect(find.text('0.0%'), findsNWidgets(2));
  });

  testWidgets('botão limpar métricas zera o relatório após confirmar', (
    WidgetTester tester,
  ) async {
    final provider = await makeProvider();

    await pumpScreen(tester, provider);

    await tapVisible(tester, 'Limpar Métricas');

    expect(find.text('Limpar Métricas?'), findsOneWidget);

    await tester.tap(find.text('Limpar'));
    await tester.pumpAndSettle();

    expect(provider.metrics.events, isEmpty);
    expect(find.text('0.0%'), findsNWidgets(4));
  });

  testWidgets('cancelar a limpeza mantém as métricas', (
    WidgetTester tester,
  ) async {
    final provider = await makeProvider();

    await pumpScreen(tester, provider);

    await tapVisible(tester, 'Limpar Métricas');
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(provider.metrics.events, hasLength(2));
    expect(find.text('100.0%'), findsNWidgets(2));
  });
}