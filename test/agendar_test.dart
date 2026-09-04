import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/core/constants/app_strings.dart';
import 'package:barberflow_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ab_test_assigned': true,
      'ab_test_variant': 'control',
    });
  });

  testWidgets('botão AGENDAR HORÁRIO leva à tela de agendamento', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BarberFlowApp());
    await tester.pumpAndSettle();

    final button = find.text(AppStrings.btnScheduleNow);
    expect(button, findsOneWidget);

    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Escolha o serviço'), findsOneWidget);
    expect(find.text('Escolha o barbeiro'), findsOneWidget);
  });
}