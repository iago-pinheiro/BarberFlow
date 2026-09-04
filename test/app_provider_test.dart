import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/core/providers/app_provider.dart';
import 'package:barberflow_app/core/services/ab_test_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'ab_test_assigned': true,
      'ab_test_variant': 'treatment',
    });
  });

  group('AppProvider', () {
    test('initialize carrega variante e registra visualização', () async {
      final provider = AppProvider();
      var notified = 0;
      provider.addListener(() => notified++);

      await provider.initialize();

      expect(provider.variant, ABVariant.treatment);
      expect(provider.isTreatment, isTrue);
      expect(provider.metrics.getViewsForVariant('treatment'), 1);
      expect(provider.abTest.variant, ABVariant.treatment);
      expect(notified, 1);
    });

    test('initialize com variante controle', () async {
      SharedPreferences.setMockInitialValues({
        'ab_test_assigned': true,
        'ab_test_variant': 'control',
      });
      final provider = AppProvider();

      await provider.initialize();

      expect(provider.variant, ABVariant.control);
      expect(provider.isTreatment, isFalse);
    });

    test('trackEvent registra evento com a variante atual', () async {
      final provider = AppProvider();
      await provider.initialize();

      await provider.trackEvent('screen_view');

      expect(provider.metrics.getViewsForVariant('treatment'), 2);
      expect(provider.metrics.getViewsForVariant('control'), 0);
    });

    test('trackEvent com propriedades', () async {
      final provider = AppProvider();
      await provider.initialize();

      await provider.trackEvent('cta_click', properties: {'section': 'hero'});

      final event = provider.metrics.events.last;
      expect(event.properties, {'section': 'hero'});
    });
  });
}
