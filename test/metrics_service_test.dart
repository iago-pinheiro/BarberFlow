import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberflow_app/core/services/metrics_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('MetricsService', () {
    test('inicia sem eventos', () async {
      final service = MetricsService();

      await service.initialize();

      expect(service.events, isEmpty);
    });

    test('trackEvent adiciona evento com timestamp', () async {
      final service = MetricsService();
      await service.initialize();

      await service.trackEvent('screen_view', 'control');

      expect(service.events, hasLength(1));
      expect(service.events.first.eventName, 'screen_view');
      expect(service.events.first.variant, 'control');
      expect(service.events.first.timestamp, isNotNull);
    });

    test('getViewsForVariant conta apenas screen_view da variante', () async {
      final service = MetricsService();
      await service.initialize();

      await service.trackEvent('screen_view', 'control');
      await service.trackEvent('screen_view', 'control');
      await service.trackEvent('screen_view', 'treatment');
      await service.trackEvent('cta_click', 'control');

      expect(service.getViewsForVariant('control'), 2);
      expect(service.getViewsForVariant('treatment'), 1);
    });

    test('getClicksForVariant conta apenas cta_click da variante', () async {
      final service = MetricsService();
      await service.initialize();

      await service.trackEvent('cta_click', 'treatment');
      await service.trackEvent('cta_click', 'treatment');
      await service.trackEvent('screen_view', 'treatment');

      expect(service.getClicksForVariant('treatment'), 2);
    });

    test('getBookingsForVariant conta apenas booking_confirmed', () async {
      final service = MetricsService();
      await service.initialize();

      await service.trackEvent('booking_confirmed', 'control');
      await service.trackEvent('booking_confirmed', 'treatment');
      await service.trackEvent('screen_view', 'control');

      expect(service.getBookingsForVariant('control'), 1);
      expect(service.getBookingsForVariant('treatment'), 1);
    });

    test('getConversionRate retorna zero sem views', () async {
      final service = MetricsService();
      await service.initialize();

      expect(service.getConversionRate('control'), 0);
    });

    test('getConversionRate divide bookings por views', () async {
      final service = MetricsService();
      await service.initialize();
      await service.trackEvent('screen_view', 'control');
      await service.trackEvent('screen_view', 'control');
      await service.trackEvent('booking_confirmed', 'control');

      expect(service.getConversionRate('control'), 0.5);
    });

    test('getReport monta relatório por variante com conversão formatada', () async {
      final service = MetricsService();
      await service.initialize();
      await service.trackEvent('screen_view', 'control');
      await service.trackEvent('booking_confirmed', 'control');
      await service.trackEvent('screen_view', 'treatment');

      final report = service.getReport();

      expect(report['control']!['views'], 1);
      expect(report['control']!['clicks'], 0);
      expect(report['control']!['bookings'], 1);
      expect(report['control']!['conversion'], '100.0');
      expect(report['treatment']!['views'], 1);
      expect(report['treatment']!['conversion'], '0.0');
    });

    test('clearEvents remove todos os eventos', () async {
      final service = MetricsService();
      await service.initialize();
      await service.trackEvent('screen_view', 'control');

      await service.clearEvents();

      expect(service.events, isEmpty);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ab_test_events'), isNull);
    });

    test('eventos são persistidos e restaurados na inicialização', () async {
      final service = MetricsService();
      await service.initialize();
      await service.trackEvent('screen_view', 'control', properties: {'x': 1});

      final restored = MetricsService();
      await restored.initialize();

      expect(restored.events, hasLength(1));
      expect(restored.events.first.eventName, 'screen_view');
      expect(restored.events.first.variant, 'control');
      expect(restored.events.first.properties, {'x': 1});
    });
  });
}