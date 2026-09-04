import 'package:flutter/foundation.dart';
import '../services/ab_test_service.dart';
import '../services/metrics_service.dart';

class AppProvider extends ChangeNotifier {
  final ABTestService _abTestService = ABTestService();
  final MetricsService _metricsService = MetricsService();

  ABTestService get abTest => _abTestService;
  MetricsService get metrics => _metricsService;

  ABVariant get variant => _abTestService.variant;
  bool get isTreatment => _abTestService.isTreatment;

  Future<void> initialize() async {
    await _abTestService.initialize();
    await _metricsService.initialize();
    notifyListeners();
  }

  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) async {
    await _metricsService.trackEvent(
      eventName,
      variant.name,
      properties: properties,
    );
    notifyListeners();
  }

  Future<void> clearMetrics() async {
    await _metricsService.clearEvents();
    notifyListeners();
  }

  @Deprecated('Use AppProvider.initialize and the AB test service instead.')
  void setVariant(ABVariant variant) {}

  @Deprecated('Use AppProvider.initialize instead.')
  Future<void> loadVariant() async {}
}
