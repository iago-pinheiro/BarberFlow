import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/core/services/ab_test_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ABTestService', () {
    test('nova instalação recebe uma variante e persiste', () async {
      final service = ABTestService();

      await service.initialize();

      expect(service.variant, isIn(ABVariant.values));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('ab_test_assigned'), isTrue);
      expect(prefs.getString('ab_test_variant'), equals(service.variant.name));
    });

    test('classifica como tratamento apenas na variante treatment', () async {
      SharedPreferences.setMockInitialValues({
        'ab_test_assigned': true,
        'ab_test_variant': 'treatment',
      });
      final service = ABTestService();

      await service.initialize();

      expect(service.variant, ABVariant.treatment);
      expect(service.isTreatment, isTrue);
    });

    test('restaura variante previamente atribuída (controle)', () async {
      SharedPreferences.setMockInitialValues({
        'ab_test_assigned': true,
        'ab_test_variant': 'control',
      });
      final service = ABTestService();

      await service.initialize();
      await service.initialize();

      expect(service.variant, ABVariant.control);
      expect(service.isTreatment, isFalse);
    });

    test('valor salvo inválido cai para controle', () async {
      SharedPreferences.setMockInitialValues({
        'ab_test_assigned': true,
        'ab_test_variant': 'desconhecido',
      });
      final service = ABTestService();

      await service.initialize();

      expect(service.variant, ABVariant.control);
    });

    test('instância nova sem flag atribuída preserva a variante escolhida', () async {
      final service = ABTestService();
      await service.initialize();
      final first = service.variant;

      await service.initialize();

      expect(service.variant, first);
    });
  });
}