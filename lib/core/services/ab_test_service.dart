import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

enum ABVariant { control, treatment }

class ABTestService {
  static const String _variantKey = 'ab_test_variant';
  static const String _assignedKey = 'ab_test_assigned';

  ABVariant _variant = ABVariant.control;
  bool _isAssigned = false;

  ABVariant get variant => _variant;
  bool get isTreatment => _variant == ABVariant.treatment;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isAssigned = prefs.getBool(_assignedKey) ?? false;

    if (!_isAssigned) {
      _variant = Random().nextBool() ? ABVariant.control : ABVariant.treatment;
      await prefs.setString(_variantKey, _variant.name);
      await prefs.setBool(_assignedKey, true);
    } else {
      final saved = prefs.getString(_variantKey) ?? 'control';
      _variant = saved == 'treatment' ? ABVariant.treatment : ABVariant.control;
    }
  }
}