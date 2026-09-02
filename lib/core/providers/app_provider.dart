import 'package:flutter/foundation.dart';

enum ABVariant { control, treatment }

class AppProvider extends ChangeNotifier {
  ABVariant _variant = ABVariant.control;

  ABVariant get variant => _variant;
  bool get isTreatment => _variant == ABVariant.treatment;

  void setVariant(ABVariant variant) {
    _variant = variant;
    notifyListeners();
  }

  Future<void> loadVariant() async {
    _variant = ABVariant.control;
    notifyListeners();
  }
}