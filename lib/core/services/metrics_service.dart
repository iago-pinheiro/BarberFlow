import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MetricEvent {
  final String eventName;
  final String variant;
  final DateTime timestamp;
  final Map<String, dynamic>? properties;

  MetricEvent({
    required this.eventName,
    required this.variant,
    required this.timestamp,
    this.properties,
  });

  Map<String, dynamic> toJson() => {
    'event': eventName,
    'variant': variant,
    'timestamp': timestamp.toIso8601String(),
    if (properties != null) ...properties!,
  };

  factory MetricEvent.fromJson(Map<String, dynamic> json) => MetricEvent(
    eventName: json['event'] as String,
    variant: json['variant'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    properties: json..remove('event')..remove('variant')..remove('timestamp'),
  );
}

class MetricsService {
  static const String _eventsKey = 'ab_test_events';
  final List<MetricEvent> _events = [];

  List<MetricEvent> get events => List.unmodifiable(_events);

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_eventsKey);
    if (data != null) {
      final list = jsonDecode(data) as List;
      _events.addAll(list.map((e) => MetricEvent.fromJson(e as Map<String, dynamic>)));
    }
  }

  Future<void> trackEvent(String eventName, String variant, {Map<String, dynamic>? properties}) async {
    final event = MetricEvent(
      eventName: eventName,
      variant: variant,
      timestamp: DateTime.now(),
      properties: properties,
    );
    _events.add(event);
    await _saveEvents();
  }

  int getViewsForVariant(String variant) =>
      _events.where((e) => e.eventName == 'screen_view' && e.variant == variant).length;

  int getClicksForVariant(String variant) =>
      _events.where((e) => e.eventName == 'cta_click' && e.variant == variant).length;

  int getBookingsForVariant(String variant) =>
      _events.where((e) => e.eventName == 'booking_confirmed' && e.variant == variant).length;

  double getConversionRate(String variant) {
    final views = getViewsForVariant(variant);
    if (views == 0) return 0;
    return getBookingsForVariant(variant) / views;
  }

  Map<String, dynamic> getReport() {
    return {
      'control': {
        'views': getViewsForVariant('control'),
        'clicks': getClicksForVariant('control'),
        'bookings': getBookingsForVariant('control'),
        'conversion': (getConversionRate('control') * 100).toStringAsFixed(1),
      },
      'treatment': {
        'views': getViewsForVariant('treatment'),
        'clicks': getClicksForVariant('treatment'),
        'bookings': getBookingsForVariant('treatment'),
        'conversion': (getConversionRate('treatment') * 100).toStringAsFixed(1),
      },
    };
  }

  Future<void> clearEvents() async {
    _events.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_events.map((e) => e.toJson()).toList());
    await prefs.setString(_eventsKey, data);
  }
}